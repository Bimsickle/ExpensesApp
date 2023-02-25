using ExpensesAppLibrary.Data;
using ExpensesAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.ComponentModel.DataAnnotations;

namespace ExpensesWebApp.Pages
{
    public class TransactionListModel : PageModel
    {
        
        [BindProperty(SupportsGet =true), DataType(DataType.Date)]
        public DateTime startDate { get; set; } = DateTime.Now.AddDays(-28);

        [BindProperty(SupportsGet =true), DataType(DataType.Date)]
        public DateTime endDate { get; set; } = DateTime.Now.AddDays(7);

        [BindProperty(SupportsGet = true)]
        public bool SearchComplete { get; set; } = false;

        [BindProperty(SupportsGet = true)]
        public int account { get; set; } = -1;
        [BindProperty(SupportsGet =true)]
        public string AccountName { get; set; }
        [BindProperty(SupportsGet = true)]
        public int? recurr { get; set; } 

        [BindProperty(SupportsGet = true)]
        public bool accountSelected { get; set; } = false;
                
        public List<TransactionStatement> Transactions { get; set; }
        public ISqlData _db { get; }

        public TransactionListModel(ISqlData db)
        {
            _db = db;
        }
        public void OnGet()
        {
            if (startDate> endDate)
            {
                startDate = endDate.AddDays(-28);
            }
            if (SearchComplete == true)
            {
                // Convert razor date time to date only
                //DateOnly start = DateOnly.FromDateTime(startDate);
                //DateOnly end = DateOnly.FromDateTime(endDate);

                //Transactions = _db.GetTransactionStatement(startDate, endDate);
            }
            if (account != -1)
            {
                Transactions = _db.GetTransactionStatement(startDate, endDate, account);
                accountSelected = true;
            }
            else if (recurr!= null)
            {
                Transactions = _db.GetTransactionStatement(startDate, endDate, null, recurr);
            }
            else
            {
                Transactions = _db.GetTransactionStatement(startDate, endDate);
            }
        }
        public IActionResult OnPost()
        {
            if (startDate > endDate)
            {
                startDate = endDate.AddDays(-28);
            }
            return RedirectToPage(new {
                SearchComplete = true,
                startDate = startDate.ToString("yyyy-MM-dd"),
                endDate = endDate.ToString("yyyy-MM-dd"),
                accountSelected,
                account,
                AccountName,
                recurr
            });
        }
    }
}
