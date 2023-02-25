using ExpensesAppLibrary.Data;
using ExpensesAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace ExpensesWebApp.Pages
{
    public class RecurringExpensesModel : PageModel
    {
        [BindProperty(SupportsGet =true)]
        public int selected { get; set; }
        [BindProperty(SupportsGet =true)]
        public List<RecurringExpenseModel> RecurringExpenses { get; set; }
        [BindProperty(SupportsGet =true)]
        public List<FrequencyModel> Frequencies { get; set; }
        public ISqlData _db { get; }

        public RecurringExpensesModel(ISqlData db)
        {
            _db = db;            
        }
        public void OnGet()
        {
            RecurringExpenses = _db.getRecurringExpenseList();
            Frequencies = _db.GetFrequencies();
        }
    }
}
