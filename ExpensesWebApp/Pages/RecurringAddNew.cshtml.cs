using ExpensesAppLibrary.Data;
using ExpensesAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace ExpensesWebApp.Pages
{
    public class RecurringAddNewModel : PageModel
    {
        
        [BindProperty(SupportsGet =true)]
        public RecurringExpenseModel recurring { get; set; }

        public List<FrequencyModel> Frequency { get; set; }

        [BindProperty(SupportsGet = true)]
        public List<SelectListItem> FrequencyOptions { get; set; }
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
        public bool Indefinite { get; set; } = true;
        [BindProperty]
        public bool calcIncreaseDate { get; set; } = false;
        public ISqlData _db { get; }

        public RecurringAddNewModel(ISqlData db)
        {
            _db = db;            
        }
        public void OnGet()
        {
            recurring = new RecurringExpenseModel();
            recurring.DateStart = DateTime.Now;
            recurring.DateEnd = DateTime.Now;
            recurring.IncreaseDate = DateTime.Now.AddDays(21);

            Frequency = _db.GetFrequencies();
            FrequencyOptions = Frequency.Select(f => new SelectListItem { Value = f.Id.ToString(), Text = f.Frequency, Selected = (f.Frequency == "Monthly") }).ToList();
            IncreaseTypes = _db.getIncreaseType();
            IncreaseTypeOptions = IncreaseTypes.Select(f => new SelectListItem { Value = f.Id.ToString(), Text = f.Type}).ToList();

            accounts = _db.GetBankBalances(DateTime.Now);
            AccountOptions = accounts.Select(f => new SelectListItem
            {
                Value = f.CostAccountID.ToString(),
                Text = String.Format("{0}: {1} (Current Balance: {2:C})", f.Account, f.AccountName, f.AvailableBalance)
            }).ToList();

            debitAccounts = _db.GetCostAccount(accountType);
            recurring.CostAccountID = debitAccounts.First().Id;
            DebitOptions = debitAccounts.Select(f => new SelectListItem { Value = f.Id.ToString(), Text = f.Description, Selected = (f.Id == recurring.CostAccountID) }).ToList();
        }
        public IActionResult OnPost()
        {
            Console.WriteLine(recurring.Description);
            int newRecurranceId = CreateRecurrance();
            return RedirectToPage("RecurringExpenses", new
             {
                selected = newRecurranceId
            });
        }

        private int CreateRecurrance()
        {
            int id;
            DateTime? finishdate = null;
            DateTime? increaseDate = null;
            int? increasetype = null;
            if (!Indefinite)
            {
                DateTime endCalc = (DateTime.Now > recurring.DateEnd ? DateTime.Now : recurring.DateEnd);
                DateTime instanceDate = DateTime.Now;
                if (recurring.Instances > 0)
                {
                    instanceDate = GetFrequencyDate(recurring.Instances, recurring.FrequencyCycleID, recurring.FrequencyCycleIncrem, recurring.DateStart);
                }
                finishdate = (endCalc > instanceDate ? endCalc : instanceDate);
            }

            if (recurring.Increase)
            {
                //get date for next increase
                if (calcIncreaseDate)
                {
                    increaseDate = GetFrequencyDate(1, recurring.IncreaseCycleID, recurring.IncreaseCycleIncrem, recurring.DateStart);
                }
                else
                {
                    increaseDate = recurring.IncreaseDate;
                }
                increasetype = recurring.IncreaseType;
            }
            
            id = _db.CreateRecurringTransaction(recurring.Description, recurring.Amount, recurring.FrequencyCycleID, recurring.FrequencyCycleIncrem, 
                                        recurring.CostAccountID,recurring.DefaultPayAccountID, recurring.DateStart, finishdate, recurring.Increase, 
                                        recurring.IncreaseCycleID, increaseDate, increasetype, recurring.IncreaseAmount, 
                                        recurring.IncreaseCycleIncrem);

            Console.WriteLine(id.ToString());
            return id;

        }
        private DateTime GetFrequencyDate(int occurances, int frequency,int increm,  DateTime start)
        {
            DateTime endDate = start;
            FrequencyModel freqType=new FrequencyModel();
            List< FrequencyModel> FrequencyList = _db.GetFrequencies();
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
                int nextdate = (increm*occurances) / 24;
                endDate = start.AddDays(nextdate);
            }
            else if(freqType.Frequency == "Daily")
            {
                endDate = start.AddDays(increm * occurances);
            }
            else if (freqType.Frequency == "Weekly")
            {
                endDate = start.AddDays(increm * 7 * occurances);
            }
            else if (freqType.Frequency == "Fortnightly")
            {
                endDate=start.AddDays(increm * 14 * occurances);
            }
            else if (freqType.Frequency == "Monthly")
            {
                endDate= start.AddMonths(increm * occurances);
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
