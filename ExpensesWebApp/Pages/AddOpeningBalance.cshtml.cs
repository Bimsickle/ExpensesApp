using ExpensesAppLibrary.Data;
using ExpensesAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.ComponentModel.DataAnnotations;

namespace ExpensesWebApp.Pages
{
    public class AddOpeningBalanceModel : PageModel
    {
        [BindProperty(SupportsGet =true)]
        public int account { get; set; }
        [BindProperty(SupportsGet = true)]
        public string accountName { get; set; }

        [BindProperty, DataType(DataType.Date)]
        public DateTime date { get; set; } = DateTime.Now;

        [BindProperty, DataType(DataType.Date)]
        public DateTime startDate { get; set; } = DateTime.Now.AddDays(-7);

        [BindProperty, DataType(DataType.Date)]
        public DateTime endDate { get; set; } = DateTime.Now.AddDays(7);

        [BindProperty]
        public decimal amount { get; set; }
        
        public List<TransactionStatement> Transactions { get; set; }

        public ISqlData _db { get; }

        public AddOpeningBalanceModel(ISqlData db)
        {
            _db = db;
        }

        public void OnGet()
        {
            Transactions = _db.GetTransactionStatement(startDate, endDate, account);
            //FrequencyOptions = Frequencies.Select(f => new SelectListItem { Value = f.Id.ToString(), Text = f.Frequency }).ToList();

        }
        public IActionResult OnPost()
        {
            _db.AddAccountOpeningBalance(account, amount, date);
            //Transactions = _db.GetTransactionStatement(startDate, endDate, account);
            return RedirectToAction("/TransactionList", new { account = account });
           /* return RedirectToPage(new
            {
                account = account,
                amount = amount,
                date = date,
                accountName = accountName
            });*/
        }
        
    }
}
