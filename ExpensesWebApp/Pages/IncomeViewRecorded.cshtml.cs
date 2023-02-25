using ExpensesAppLibrary.Data;
using ExpensesAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace ExpensesWebApp.Pages
{
    public class IncomeViewRecordedModel : PageModel
    {
        [BindProperty(SupportsGet = true)]
        public List<int> transactionid { get; set; }
        public List<TransactionModel> transactions { get; set; }
        public ISqlData _db { get; }
        public IncomeViewRecordedModel(ISqlData db)
        {
            _db = db;            
        }
        public void OnGet()
        {
            transactions = new List<TransactionModel>();
            foreach (var trans in transactionid)
            {
                TransactionModel t = _db.getTransaction(trans);
                transactions.Add(t);
            }
            
        }
    }
}
