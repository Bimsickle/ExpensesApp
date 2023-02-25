using ExpensesAppLibrary.Data;
using ExpensesAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.ComponentModel.DataAnnotations;

namespace ExpensesWebApp.Pages
{
    public class RecurringRecordTransactionModel : PageModel
    {
        [BindProperty(SupportsGet = true)]
        public int selected { get; set; }

        [BindProperty(SupportsGet =true)]
        public int active { get; set; }
        [BindProperty(SupportsGet = true)]
        public List<SelectListItem> Option { get; set; }

        [BindProperty(SupportsGet = true)]
        public string Description { get; set; }
        [BindProperty(SupportsGet = true), DataType(DataType.Date)]
        public DateTime LastDate { get; set; }

        /* FORM FIELDS */
        [BindProperty(SupportsGet =true)]
        public int Quantity { get; set; }

        [BindProperty(SupportsGet = true)]
        public DateTime maxDate { get; set; } = DateTime.Now;
        /* END FORM FIELDS */

        public List<TransactionModel> TransactionList { get; set; }
        public List<RecurringExpenseModel> RecurringExpense { get; set; }
        [BindProperty]
        public RecurringExpenseModel Expense { get; set; }
        public TransactionModel LatestTransaction { get; set; }
        //[BindProperty(SupportsGet = true)]
        //public bool dateSelected { get; set; } = true;
        //[BindProperty(SupportsGet = true)]
        //public bool quantSelected { get; set; } = false;
        [BindProperty(SupportsGet =true)]
        public string optionSelected { get; set; } = "0";

        public ISqlData _db { get; }

        public RecurringRecordTransactionModel(ISqlData db)
        {
            _db = db;
            TransactionList = new List<TransactionModel>();
            LatestTransaction = new TransactionModel();
            Option = new List<SelectListItem>();
            Expense = new RecurringExpenseModel();
        }
        public void OnGet()
        {
            Console.WriteLine(selected.ToString());

            //TransactionList = new List<TransactionModel>();
            //LatestTransaction = new TransactionModel();
            Option = new List<SelectListItem>() { new SelectListItem() { Value = "0", Text = "Add until End date" },
                                        new SelectListItem() { Value = "1", Text = "Add # of Occurances" }};

            RecurringExpense = _db.getRecurringExpenseList(selected, active);
            Expense = RecurringExpense.FirstOrDefault();
            LatestTransaction = _db.getLatestRecordedRecurringTransaction(selected).FirstOrDefault();

            if (LatestTransaction != null)
            {
                LastDate = LatestTransaction.DatePaid;
            }
            else
            {
                LastDate = Expense.DateStart;
            }
            Console.WriteLine(LastDate.ToString());
            if (Expense != null)
            {
                Description = Expense.Description;
            }

            //Console.WriteLine(Expense.Description);
        }
        public IActionResult OnPost()
        {
            Console.WriteLine("In Post");
            
            //setDefaults();
            //Console.WriteLine(quantSelected.ToString());
            Console.WriteLine(Quantity.ToString());
            int number = 0;
            Console.WriteLine(Expense.Description);
            //Console.WriteLine(LatestTransaction.Description);
            if (optionSelected=="1")
            {
                number = Quantity;
            }
            else
            {
                number = getMaxDateCount(Expense.FrequencyCycleID, Expense.FrequencyCycleIncrem, LastDate, maxDate);
            }
            RecordTransactions(number);
            return RedirectToPage("RecurringExpenses",new
            {
                //Transactions with cost code & recuurance??
                //selected= selected, active = active
            });
        }
        public void RecordTransactions(int quantity)
        {
            //int recordTransaction(int debit, int credit, decimal amount, DateTime date, string description, int confirmed, int ? reccur)
            DateTime date = (Expense.DateStart> LastDate ? Expense.DateStart : LastDate);
            for (int i = 0; i< quantity+1; i++)
            {
                //calculate date
                _db.recordTransaction(Expense.CostAccountID, Expense.DefaultPayAccountID, Expense.Amount, date, Expense.Description, 0, Expense.Id);
                date = GetFrequencyDate(1, Expense.FrequencyCycleID, Expense.FrequencyCycleIncrem, date);
            }
        }
        public int getMaxDateCount(int frequency, int increm, DateTime start, DateTime end)
        {
            int occurances = 0;
            DateTime nextdate = start;
            do
            {
                maxDate = GetFrequencyDate(1, Expense.FrequencyCycleID, Expense.FrequencyCycleID, nextdate);
                occurances++;
            }
            while (end > maxDate);
            return occurances;
        }
        public DateTime GetFrequencyDate(int occurances, int frequency, int increm, DateTime start)
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
