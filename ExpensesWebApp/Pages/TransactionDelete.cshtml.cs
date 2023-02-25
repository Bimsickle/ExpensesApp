using ExpensesAppLibrary.Data;
using ExpensesAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace ExpensesWebApp.Pages
{
    public class TransactionDeleteModel : PageModel
    {
        [BindProperty(SupportsGet = true)]
        public int selected { get; set; }
        [BindProperty(SupportsGet =true)]
        public bool deleted { get; set; }= false;
        [BindProperty(SupportsGet =true)]
        public DateTime endDate { get; set; }
        [BindProperty(SupportsGet =true)]
        public string Description { get; set; }
        [BindProperty]
        public TransactionModel transaction { get; set; }
        public ISqlData _db { get; }

        public TransactionDeleteModel(ISqlData db)
        {
            _db = db;            
        }
        public void OnGet()
        {
            transaction = _db.getTransaction(selected);
            if(transaction != null)
            {
                endDate = transaction.DatePaid;
                Description = transaction.Description;
            }
        }
        public IActionResult OnPost()
        {                        
            _db.DeleteTransaction(selected);
            deleted = true;
            return RedirectToPage( new
            {
                deleted,
                Description, 
                endDate = endDate.ToString("yyyy-MM-dd")
            });
        }
    }
}
