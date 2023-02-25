using ExpensesAppLibrary.Data;
using ExpensesAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.ComponentModel.DataAnnotations;

namespace ExpensesWebApp.Pages
{
    public class BankAccountBalanceModel : PageModel
    {
        [BindProperty(SupportsGet = true), DataType(DataType.Date)]
        public DateTime DateEnd { get; set; } = DateTime.Now;
        public decimal Balance { get; set; } = 0;
        public decimal AvailableBalance { get; set; } = 0;

        public List<BankBalanceModel> BankAccounts { get; set; }
        public ISqlData _db { get; }

        public BankAccountBalanceModel(ISqlData db)
        {
            _db = db;
        }
        public void OnGet()
        {
            BankAccounts = _db.GetBankBalances(DateEnd);

            foreach (var bank in BankAccounts)
            {
                Balance += bank.Balance;
                AvailableBalance += bank.AvailableBalance;
            }
        }
        public IActionResult OnPost()
        {            
            return RedirectToPage(new
            {
                SearchComplete = true,
                DateEnd = DateEnd.ToString("yyyy-MM-dd")
            });
        }
    }
}
