using ExpensesAppLibrary.Data;
using ExpensesAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.ComponentModel.DataAnnotations;

namespace ExpensesWebApp.Pages
{
    public class TransactionEditModel : PageModel
    {
        [BindProperty(SupportsGet =true)]
        public string Duplicate { get; set; }
        [BindProperty(SupportsGet =true)]
        public int selected { get; set; }
        [BindProperty]
        public TransactionModel transaction { get; set; }

        [BindProperty(SupportsGet = true)]
        public string DebitType { get; set; } = "all";
        [BindProperty(SupportsGet = true)]
        public string CreditType { get; set; } = "all";

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



        public ISqlData _db { get; }

        public TransactionEditModel(ISqlData db)
        {
            _db = db;
        }
        public void OnGet()
        {
            if (Duplicate=="true")
            {
                selected = _db.DuplicateTransaction(selected);
                transaction = _db.getTransaction(selected);
                Duplicate = String.Format("Duplicated Transaction: {0}", transaction.Description);
            }
            else
            {
                transaction = _db.getTransaction(selected);
                Duplicate = String.Format("Edit Transaction: {0}", transaction.Description);
            }
            CostAccountModel debitModel = _db.GetCostAccountById(transaction.DebitID);
            CostAccountModel creditModel = _db.GetCostAccountById(transaction.CreditID);
            
            debit = transaction.DebitID;
            credit = transaction.CreditID;

            debitAccounts = _db.GetCostAccount(DebitType);
            creditAccounts = _db.GetCostAccount(CreditType);
            DebitOptions = debitAccounts.Select(f => new SelectListItem { Value = f.Id.ToString(), Text = f.Description, Selected = (f.Id == debit) }).ToList();
            CreditOptions = creditAccounts.Select(f => new SelectListItem { Value = f.Id.ToString(), Text = f.Description, Selected = (f.Id == credit) }).ToList();
        }

        public IActionResult OnPost()
        {
            DateTime endDate = transaction.DatePaid;
            int conf = 0;
            int? rec= null;
            if (transaction.Confirmed) { conf = 1; }
            if (transaction.RecurranceID != 0) { rec= transaction.RecurranceID;}
            _db.UpdateTransaction(selected, transaction.DatePaid, conf, transaction.Description, debit, credit, transaction.Amount, rec);
            DateTime setdate = transaction.DatePaid;
            return RedirectToPage("/TransactionList",new
            {
                endDate = endDate
            });
        }
    }
}
