using ExpensesAppLibrary.Data;
using ExpensesAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace ExpensesWebApp.Pages
{
    public class RecurringEditModel : PageModel
    {
        [BindProperty(SupportsGet = true)]
        public int selected { get; set; }
        [BindProperty]
        public RecurringExpenseModel Expense { get; set; }
        [BindProperty]
        public bool Active { get; set; }
        public List<FrequencyModel> Frequency { get; set; }

        [BindProperty(SupportsGet = true)]
        public List<SelectListItem> FrequencyOptions { get; set; }
        public List<RecurringExpenseModel> RecurringExpenses { get; set; }
        public List<BankBalanceModel> accounts { get; set; }
        [BindProperty(SupportsGet = true)]
        public List<SelectListItem> AccountOptions { get; set; }

        [BindProperty(SupportsGet = true)]
        public string accountType { get; set; } = "expense";
        public List<IncreaseType> IncreaseTypes { get; set; }
        public List<CostAccountModel> debitAccounts { get; set; }
        public List<SelectListItem> DebitOptions { get; set; }
        public List<SelectListItem> IncreaseTypeOptions { get; set; }
        [BindProperty]
        public bool Indefinite { get; set; } = false;
        [BindProperty]
        public bool calcIncreaseDate { get; set; } = false;


        public ISqlData _db { get; }

        public RecurringEditModel(ISqlData db)
        {
            _db = db;
        }
        public void OnGet()
        {
            RecurringExpenses = _db.getRecurringExpenseList(selected);
            Expense = RecurringExpenses.FirstOrDefault();
            if (Expense.Active == 1)
            {
                Active = true;
            }
            else
            {
                Active = false;
            }

            if (DateTime.Compare(Expense.DateEnd, Convert.ToDateTime("1/1/2002")) >= 0)
            {
                Indefinite = true;
            }
            else
            {
                Expense.DateEnd=DateTime.Now;
            }
            Console.WriteLine(Expense.Increase.ToString());
            Frequency = _db.GetFrequencies();
            FrequencyOptions = Frequency.Select(f => new SelectListItem { Value = f.Id.ToString(), Text = f.Frequency, Selected = (f.Frequency == "Monthly") }).ToList();
            IncreaseTypes = _db.getIncreaseType();
            IncreaseTypeOptions = IncreaseTypes.Select(f => new SelectListItem { Value = f.Id.ToString(), Text = f.Type }).ToList();

            accounts = _db.GetBankBalances(DateTime.Now);
            AccountOptions = accounts.Select(f => new SelectListItem
                            {
                                Value = f.CostAccountID.ToString(),
                                Text = String.Format("{0}: {1} (Current Balance: {2:C})", f.Account, f.AccountName, f.AvailableBalance)
                            }).ToList();

            debitAccounts = _db.GetCostAccount(accountType);
            DebitOptions = debitAccounts.Select(f => new SelectListItem { Value = f.Id.ToString(), Text = f.Description, Selected = (f.Id == Expense.CostAccountID) }).ToList();
        }
        public IActionResult OnPost()
        {
            Console.WriteLine("Success");
            Console.WriteLine(Expense.Id.ToString());   
            DateTime? finishdate = null;
            if (!Indefinite)
            {
                DateTime endCalc = (DateTime.Now > Expense.DateEnd ? DateTime.Now : Expense.DateEnd);
                DateTime instanceDate = DateTime.Now;
                if (Expense.Instances > 0)
                {
                    instanceDate = GetFrequencyDate(Expense.Instances, Expense.FrequencyCycleID, Expense.FrequencyCycleIncrem, Expense.DateStart);
                }
                finishdate = (endCalc > instanceDate ? endCalc : instanceDate);
            }
            DateTime? increasedate = null;
            if (Expense.Increase)
            {
                increasedate = Expense.IncreaseDate;
            }
            if (Active)
            {
                Console.WriteLine("active");
                Expense.Active = 1;
            }
            else
            {
                Console.WriteLine("inactive");
                Expense.Active = 0;
            }
            //dates if null
            //addtypes
            _db.UpdateRecurringTransaction(
                                            selected, 
                                            Expense.Description,
                                            Expense.Active,
                                            Expense.Amount,
                                            Expense.FrequencyCycleID,
                                            Expense.FrequencyCycleIncrem,
                                            Expense.CostAccountID,
                                            Expense.DefaultPayAccountID,
                                            Expense.DateStart,
                                            finishdate,
                                            Expense.Increase,
                                            Expense.IncreaseCycleID,
                                            increasedate,
                                            Expense.IncreaseType,
                                            Expense.IncreaseAmount,
                                            Expense.IncreaseCycleIncrem);

            return RedirectToPage("RecurringExpenses", new
            {
                selected = selected
            });
        }
        private DateTime GetFrequencyDate(int occurances, int frequency, int increm, DateTime start)
        {
            DateTime endDate = start;
            FrequencyModel freqType = new FrequencyModel();
            List<FrequencyModel> FrequencyList = _db.GetFrequencies();
            foreach (FrequencyModel freq in FrequencyList)
            {
                if (freq.Id == frequency)
                {
                    freqType = freq;
                    break;
                }
            }
            if (freqType.Frequency == "Hourly")
            {
                int nextdate = (increm * occurances) / 24;
                endDate = start.AddDays(nextdate);
            }
            else if (freqType.Frequency == "Daily")
            {
                endDate = start.AddDays(increm * occurances);
            }
            else if (freqType.Frequency == "Weekly")
            {
                endDate = start.AddDays(increm * 7 * occurances);
            }
            else if (freqType.Frequency == "Fortnightly")
            {
                endDate = start.AddDays(increm * 14 * occurances);
            }
            else if (freqType.Frequency == "Monthly")
            {
                endDate = start.AddMonths(increm * occurances);
            }
            else if (freqType.Frequency == "Quarterly")
            {
                endDate = start.AddMonths(increm * 3 * occurances);
            }
            else
            {
                endDate = start.AddYears(increm * occurances);
            }
            return endDate;
        }
    }
}
