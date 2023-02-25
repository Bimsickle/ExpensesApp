using ExpensesAppLibrary.Data;
using ExpensesAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.ComponentModel.DataAnnotations;

namespace ExpensesWebApp.Pages
{
    public class IncomeRecordModel : PageModel
    {
        [BindProperty(SupportsGet = true)]
        public int income { get; set; }
        public List<IncomeModel> IncomeAccounts { get; set; }
        public List<BankBalanceModel> accounts { get; set; }
        [BindProperty(SupportsGet = true)]
        public List<SelectListItem> AccountOptions { get; set; }
        [BindProperty]
        public IncomeModel SelectedIncome { get; set; }

        private TaxRateModel taxRate { get; set; }
        private List<CostAccountModel> taxAccounts { get; set; }
        public TransactionModel LastTransaction { get; set; }
        public List<SelectListItem> IncomeOptions { get; set; }
        public LoanModel loanModel { get; set; }
        [BindProperty]
        public decimal DefaultPayAmount { get; set; } = 0;

        [BindProperty(SupportsGet = true), DataType(DataType.Date)]
        public DateTime nextPayDate { get; set; }
        [BindProperty]
        public bool Confirmed { get; set; }
        public ISqlData _db { get; }
        public IncomeRecordModel(ISqlData db)
        {
            _db = db;
            IncomeAccounts = _db.GetIncomeAccounts();
            IncomeOptions = IncomeAccounts.Select(f => new SelectListItem { Value = f.Id.ToString(), Text = f.Description }).ToList();
            SelectedIncome = _db.GetIncomeAccounts(income).FirstOrDefault();
            //taxAccounts = _db.getTaxAccounts();
        }
        public void OnGet()
        {
            IncomeAccounts = _db.GetIncomeAccounts();
            IncomeOptions = IncomeAccounts.Select(f => new SelectListItem { Value = f.Id.ToString(), Text = f.Description }).ToList();
            SelectedIncome = _db.GetIncomeAccounts(income).FirstOrDefault();
            accounts = _db.GetBankBalances(DateTime.Now);
            AccountOptions = accounts.Select(f => new SelectListItem
            {
                Value = f.CostAccountID.ToString(),
                Text = String.Format("{0}: {1} (Current Balance: {2:C})", f.Account, f.AccountName, f.AvailableBalance)
            }).ToList();
            //taxAccounts = _db.getTaxAccounts();


            if (SelectedIncome != null)
            {
                LastTransaction = _db.GetLatestIncomePayment(SelectedIncome.CostAccountID);
                //taxRate = _db.getTaxRateDetails(SelectedIncome.SalaryTaxID);
                //loanModel = _db.getEducationLoans();
            }
            if (income!=0)
            {
                DefaultPayAmount = SelectedIncome.DefaultPayAmount();
                nextPayDate = NextPayDate();
            }
            //
        }
        public IActionResult OnPost()
        {
            Console.WriteLine(Confirmed);
            if (Confirmed)
            {
                List<int> transid = RecordSalary();

                return RedirectToPage("/IncomeViewRecorded", new
                {
                    transactionid = transid
                });
            }
            return RedirectToPage(new
            {
                income
            });
        }
        // record super??
        public List<int> RecordSalary()
        {
            SelectedIncome = _db.GetIncomeAccounts(income).FirstOrDefault();
            taxAccounts = _db.getTaxAccounts();
            loanModel = _db.getEducationLoans();
            taxRate = _db.getTaxRateDetails(SelectedIncome.SalaryTaxID);
            List<int> transactionIds = new List<int>();

            
            int loan = 0;
            decimal balance = DefaultPayAmount;
            if (SelectedIncome.HoldTaxStudentLoan)
            {
                var amount = Math.Ceiling(DefaultPayAmount * taxRate.HELLP);
                var loandesc = "Student Loan Payment";
                balance -=amount;
                loan = _db.recordTransaction(loanModel.CostAccountID, SelectedIncome.CostAccountID, amount, nextPayDate, loandesc, 0);
                transactionIds.Add(loan);
            }
            /* Set up Taxes */
            int tax = 0;
            int taxhold = 0;
            int taxexp = 0;
            int taxinc =  0;
            foreach (var tx in taxAccounts)
            {
                if (tx.CostCentre == 4)
                {
                    taxhold = tx.Id;
                }
                if (tx.CostCentre == 3)
                {
                    taxexp = tx.Id;
                }
                if(tx.CostCentre == 6)
                {
                    taxinc = tx.Id;
                }
            }
            var taxamount = Math.Round(getTaxAmount());
            Console.WriteLine(taxamount);
            balance -= taxamount;
            if (taxamount > 0)
            {
                var taxdesc = String.Format("Tax Holding: {0}", SelectedIncome.Description);
                if (SelectedIncome.TaxHeld)
                {
                    int hold = _db.recordTransaction(taxinc, SelectedIncome.CostAccountID, taxamount, nextPayDate, taxdesc, 0); //Negates Revenue #6 +-
                    taxdesc = "Tax Paid";
                    tax = _db.recordTransaction(taxexp, taxinc, taxamount, nextPayDate, taxdesc, 0); // Moves from Revenue to Expense 6>3
                    transactionIds.Add(tax);
                }
                else
                {
                    int hold = _db.recordTransaction(taxinc, taxhold, taxamount, nextPayDate, taxdesc, 0); //Negates Revenue #6 +-
                    //Creates a Tax liability and pays into Bank account
                    tax = _db.recordTransaction(SelectedIncome.BankAccountID, SelectedIncome.CostAccountID, taxamount, nextPayDate, taxdesc, 0); 
                    transactionIds.Add(tax);
                }
            }
            /* Calculate Salary */
            var desc = String.Format("Salary: {0}", SelectedIncome.Description);
            int salary = _db.recordTransaction(SelectedIncome.BankAccountID, SelectedIncome.CostAccountID, balance, nextPayDate, desc, 0);
            transactionIds.Add(salary);

            return transactionIds;
        }
        private decimal getTaxAmount()
        {
            Console.WriteLine(SelectedIncome.PayCycle);
            // Get pay cycle
            if (SelectedIncome.PayCycle == 2)
            {
                //day
                var balance = DefaultPayAmount*365;
                var med = DefaultPayAmount * 365 * taxRate.MedicareLevy;
                if (balance >= taxRate.TaxThreshold)
                {
                    // Check if this payment is unusally small for the tax bracket
                    balance -= taxRate.TaxThreshold;
                }
                balance *= taxRate.TaxPercent;
                balance += med;
                return (balance + taxRate.Base)/365;
            }
            else if (SelectedIncome.PayCycle == 3)
            {
                // week
                var balance = DefaultPayAmount*52;
                var med = DefaultPayAmount * 52 * taxRate.MedicareLevy;
                if (balance>= taxRate.TaxThreshold)
                {
                    // Check if this payment is unusally small for the tax bracket
                    balance -= taxRate.TaxThreshold;
                }
                balance *= taxRate.TaxPercent;
                balance += med;
                return (balance + taxRate.Base)/52;
            }
            else if (SelectedIncome.PayCycle == 4)
            {
                //fort
                var balance = DefaultPayAmount*26;
                var med = DefaultPayAmount * 26 * taxRate.MedicareLevy;
                if (balance >= taxRate.TaxThreshold)
                {
                    // Check if this payment is unusally small for the tax bracket
                    balance -= taxRate.TaxThreshold;
                }
                balance *= taxRate.TaxPercent;
                balance += med;
                return (balance + taxRate.Base)/26;
            }
            else if (SelectedIncome.PayCycle == 5)
            {
                // month
                var balance = DefaultPayAmount*12;
                var med = DefaultPayAmount * 12 * taxRate.MedicareLevy;
                if (balance >= taxRate.TaxThreshold)
                {
                    // Check if this payment is unusally small for the tax bracket
                    balance -= taxRate.TaxThreshold;
                }
                balance *= taxRate.TaxPercent;
                balance += med;
                return (balance + taxRate.Base)/12;

            }
            else if (SelectedIncome.PayCycle == 6)
            {
                //quarter
                var balance = DefaultPayAmount*4;
                var med = DefaultPayAmount * 4 * taxRate.MedicareLevy;
                if (balance >= taxRate.TaxThreshold)
                {
                    // Check if this payment is unusally small for the tax bracket
                    balance -= taxRate.TaxThreshold;
                }
                balance *= taxRate.TaxPercent;
                balance += med;
                return (balance + taxRate.Base)/4;
            }
            //year
            var ybalance = DefaultPayAmount;
            var ymed = DefaultPayAmount * taxRate.MedicareLevy;
            if (ybalance >= taxRate.TaxThreshold)
            {
                // Check if this payment is unusally small for the tax bracket
                ybalance -= taxRate.TaxThreshold;
            }
            ybalance *= taxRate.TaxPercent;
            ybalance += ymed;
            return ybalance + taxRate.Base;
        }
        private DateTime NextPayDate()
        {
            if (LastTransaction == null)
            {
                return DateTime.Now;
            }
            // Calculate Days
            if (SelectedIncome.PayCycle == 2) // Day
            {
                return LastTransaction.DatePaid.AddDays(SelectedIncome.PayCycleInrem);
            }
            else if (SelectedIncome.PayCycle == 3) // Week
            {
                DateTime d = LastTransaction.DatePaid.AddDays(7 * SelectedIncome.PayCycleInrem);
                return d.AddDays(SelectedIncome.PayDayOfWeek - (int)d.DayOfWeek);
            }
            else if (SelectedIncome.PayCycle == 4) // Fortnight
            {
                DateTime d = LastTransaction.DatePaid.AddDays(14 * SelectedIncome.PayCycleInrem);
                return d.AddDays(SelectedIncome.PayDayOfWeek - (int)d.DayOfWeek);
            }
            else if (SelectedIncome.PayCycle == 5) // Month
            {
                return LastTransaction.DatePaid.AddMonths(SelectedIncome.PayCycleInrem);
            }
            else if (SelectedIncome.PayCycle == 6) // Quarter
            {
                return LastTransaction.DatePaid.AddDays(3 * SelectedIncome.PayCycleInrem);
            }
            else if (SelectedIncome.PayCycle == 7) // Year
            {
                return LastTransaction.DatePaid.AddYears(SelectedIncome.PayCycleInrem);
            }
            // Return today for Hours
            return DateTime.Now;
        }     

    }
}
