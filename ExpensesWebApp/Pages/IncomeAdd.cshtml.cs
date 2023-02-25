using ExpensesAppLibrary.Data;
using ExpensesAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace ExpensesWebApp.Pages
{
    public class IncomeAddModel : PageModel
    {
        [BindProperty]
        public IncomeModel Income { get; set; }
        public TaxRateModel TaxRate { get; set; }
        public List<BankBalanceModel> accounts { get; set; }
        [BindProperty(SupportsGet = true)]
        public List<SelectListItem> AccountOptions { get; set; }

        [BindProperty(SupportsGet = true)]
        public string accountType { get; set; } = "debit"; //Bank Accounts
        public List<FrequencyModel> Frequency { get; set; }

        [BindProperty(SupportsGet = true)]
        public List<SelectListItem> FrequencyOptions { get; set; }
        [BindProperty(SupportsGet =true)]
        public bool IsStudentLoan { get; set; } = false; //Set with function
        [BindProperty(SupportsGet = true)]
        public bool IsSalary { get; set; } 
        [BindProperty(SupportsGet =true)]
        public List<SelectListItem> Weekdays { get; set; }
        [BindProperty]
        public bool Tax { get; set; } = true;

        public ISqlData _db { get; }

        public IncomeAddModel(ISqlData db)
        {
            _db = db;
            Income = new IncomeModel();
        }
        public void OnGet()
        {
            Console.WriteLine("get");
            Income.StartDate = DateTime.Now;
            Income.PayStartDate = Income.StartDate.AddDays(21);
            Income.StandardWeekHours = 38;
            Income.PayCycleInrem = 1;
            Income.PayCycle = 5;
            Income.TaxHeld = true;

            IsSalary = true;

            Frequency = _db.GetFrequencies();
            FrequencyOptions = Frequency.Select(f => new SelectListItem { Value = f.Id.ToString(), Text = f.Frequency, Selected = (f.Frequency == "Monthly") }).ToList();

            accounts = _db.GetBankBalances(DateTime.Now);
            AccountOptions = accounts.Select(f => new SelectListItem
            {
                Value = f.CostAccountID.ToString(),
                Text = String.Format("{0}: {1} (Current Balance: {2:C})", f.Account, f.AccountName, f.AvailableBalance)
            }).ToList();

            int loans = _db.CountStudentLoan();
            if (loans > 0) { IsStudentLoan = true; }

            Weekdays = new List<SelectListItem>() { new SelectListItem() { Value = "1", Text = "Monday" },
                                                    new SelectListItem() { Value = "2", Text = "Tuesday" },
                                                    new SelectListItem() { Value = "3", Text = "Wednesday" },
                                                    new SelectListItem() { Value = "4", Text = "Thursday" },
                                                    new SelectListItem() { Value = "5", Text = "Friday" },
                                                    new SelectListItem() { Value = "6", Text = "Saturday" },
                                                    new SelectListItem() { Value = "7", Text = "Sunday" }};
        }
        public IActionResult OnPost()
        {
            int? tax = null;
            if (Income.Description != null)
            {
                Income.Description = "New Income";
            }

            if (Tax && !Income.TaxHeld)
            {
                Income.SalaryTaxID = 0;
            }
            else if (!Tax)
            {
                tax = 1; // No Tax
            }
            
            Income.SalaryRate = CalculateAnnual();
            int selected = _db.AddNewIncome(Income.Description, Income.StartDate, Income.SalaryRate, Income.TaxHeld, Income.SalaryCycleID, Income.StandardWeekHours, Income.PayCycle,
                        Income.PayCycleInrem, Income.StartDate, Income.PayDayOfWeek, Income.WeekendRate, Income.HolidayRate, Income.EveningRate, Income.PaidLeaveHoursAnnual,
                        Income.BankAccountID, studentLoan:IsStudentLoan);
            return RedirectToPage("/IncomeViewAll",new
            {
                selected = selected
            });
        }
        public decimal CalculateAnnual()
        {
            string frequency = null;
            Frequency = _db.GetFrequencies();
            foreach (FrequencyModel freq in Frequency)
            {
                if (freq.Id == Income.SalaryCycleID)
                {
                    frequency = freq.Frequency;
                    break;
                }
            }
            if (frequency == "Yearly") { return Income.SalaryRate; }
            else if(frequency =="Monthly") { return Income.SalaryRate*12; }
            else if(frequency=="Quarterly") { return Income.SalaryRate * 3; }
            else if(frequency=="Fortnightly") { return Income.SalaryRate * 26; }
            else if (frequency=="Weekly") { return Income.SalaryRate * 52; }
            else if(frequency=="Daily") { return Income.SalaryRate * 5 * 52; }
            else //Hourly
            {
                return Income.SalaryRate * Income.StandardWeekHours*52;
            }
        }
    }
}
