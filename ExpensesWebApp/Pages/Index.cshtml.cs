using ExpensesAppLibrary.Data;
using ExpensesAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.ComponentModel.DataAnnotations;

namespace ExpensesWebApp.Pages
{
    public class IndexModel : PageModel
    {
        [BindProperty, DataType(DataType.Date)]
        public DateTime DateEnd { get; set; } = DateTime.Now;
        [BindProperty]
        public List<BankBalanceModel> accounts { get; set; }
        [BindProperty(SupportsGet = true)]
        public List<SelectListItem> AccountOptions { get; set; }

        [BindProperty(SupportsGet = true)]
        public int AccountId { get; set; }
        [BindProperty(SupportsGet = true)]
        public string AccountName { get; set; }

        private readonly ILogger<IndexModel> _logger;
        public ISqlData _db { get; }

        public IndexModel(ILogger<IndexModel> logger, ISqlData db)
        {
            _logger = logger;
            _db = db;
        }

        public void OnGet()
        {
            accounts = _db.GetBankBalances(DateEnd);
            AccountOptions = accounts.Select(f => new SelectListItem { 
                Value = f.CostAccountID.ToString(), 
                Text = String.Format("{0}: {1} (Available Balance: {2:C}, Balance {3:C})", f.Account,f.AccountName, f.AvailableBalance, f.Balance) 
            }).ToList();
        }
        public IActionResult OnPost()
        {
            Console.WriteLine(AccountId);
            accounts = _db.GetBankBalances(DateEnd);
            foreach (var account in accounts)
            {
                if (account.CostAccountID== AccountId)
                {
                    AccountName = String.Format("({0})", account.AccountName);
                    break;
                }                    
            }           

            return RedirectToPage("/TransactionList", new
            {
                account = AccountId,
                endDate = DateEnd.ToString("yyyy-MM-dd"),
                accountSelected = true,
                AccountName = AccountName
            });
        }
    }
}