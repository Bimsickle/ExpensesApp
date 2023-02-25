using ExpensesAppLibrary.Data;
using ExpensesAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.ComponentModel.DataAnnotations;

namespace ExpensesWebApp.Pages
{
    public class SpendMoneyModel : PageModel
    {
        
        [BindProperty(SupportsGet = true)]
        public string DebitType { get; set; } = "debit";
        [BindProperty(SupportsGet = true)]
        public string CreditType { get; set; } = "expense";
        public List<CostAccountModel> debitAccounts { get; set; }
        public List<CostAccountModel> creditAccounts { get; set; }
        //[BindProperty(SupportsGet = true)]
        public List<SelectListItem> DebitOptions { get; set; }
        //[BindProperty(SupportsGet = true)]
        public List<SelectListItem> CreditOptions { get; set; }
        [BindProperty(SupportsGet = true)]
        public int debit { get; set; }
        [BindProperty(SupportsGet = true)]
        public int credit { get; set; }
        [BindProperty(SupportsGet = true), DataType(DataType.Date)]
        public DateTime date { get; set; } = DateTime.Now;
        [BindProperty]
        public string Description { get; set; }
        [BindProperty]
        public decimal amount { get; set; } = 0;
        [BindProperty(SupportsGet = true)]
        public bool lockedReceive { get; set; } = false;
        [BindProperty(SupportsGet = true)]
        public bool lockedSpend { get; set; } = false;

        public ISqlData _db { get; }
        public SpendMoneyModel(ISqlData db)
        {
            _db = db;
            debitAccounts = _db.GetCostAccount(DebitType);
            creditAccounts = _db.GetCostAccount(CreditType);
            debit = debitAccounts.First().Id;
            credit = creditAccounts.First().Id;
        }
        public void OnGet()
        {
            debitAccounts = _db.GetCostAccount(DebitType);
            creditAccounts = _db.GetCostAccount(CreditType);
            DebitOptions = debitAccounts.Select(f => new SelectListItem { Value = f.Id.ToString(), Text = f.Description, Selected = (f.Id ==debit) }).ToList();
            CreditOptions = creditAccounts.Select(f => new SelectListItem { Value = f.Id.ToString(), Text = f.Description, Selected = (f.Id == credit) }).ToList();            
        }
        public IActionResult OnPost()
        {
            if (amount != 0)
            {
                if (DebitType == "debit" | DebitType == "expense")
                {
                    int dt = debit;
                    debit = credit;
                    credit = dt;
                }
                _db.recordTransaction(debit, credit, amount, date, Description, 1, null);
                return RedirectToPage(new { });
            }
            return RedirectToPage(new
            {
                DebitType,
                CreditType,
                date = date.ToString("yyyy-MM-dd"),
                debit,
                credit,
                lockedReceive,
                lockedSpend
            });
        }
        
    }
}
