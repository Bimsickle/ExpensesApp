using ExpensesAppLibrary.Data;
using ExpensesAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.ComponentModel.DataAnnotations;

namespace ExpensesWebApp.Pages
{
    public class DebitAccountCreateModel : PageModel
    {
        [BindProperty]
        public string Description { get; set; }

        [BindProperty]
        public string Bank { get; set; }

        [BindProperty, DataType(DataType.Date)]
        public DateTime OpeningDate { get; set; } = DateTime.Now;

        [BindProperty]
        public decimal InterestRate { get; set; }
        [BindProperty]
        public decimal Fee { get; set; }
        [BindProperty]
        public int FeeCycleID { get; set; }
        [BindProperty]
        public int FreeCycleIncremum { get; set; } = 1;

        [BindProperty]
        public DebitAccountModel Account { get; set; }
        public int accountid { get; set; }
        public List<TransactionStatement> Transactions { get; set; }
        public List<FrequencyModel> Frequencies { get; set; }

        [BindProperty(SupportsGet = true)]
        public List<SelectListItem> FrequencyOptions { get; set; }
        public ISqlData _db { get; }

        public DebitAccountCreateModel(ISqlData db)
        {
            _db = db;
        }

        public void OnGet()
        {
            Frequencies = _db.GetFrequencies();
            FrequencyOptions = Frequencies.Select(f => new SelectListItem {Value = f.Id.ToString(),Text = f.Frequency}).ToList();
            
        }
        public IActionResult OnPost()
        {
            accountid = _db.CreateDebitAccount(Description, OpeningDate, InterestRate, Fee, FeeCycleID, FreeCycleIncremum, Bank);
            Account = _db.getDebitAccount(accountid);
            
            return RedirectToPage("/SuccessCreateDebitAccount", new {
                                                            account = Account.CostAccountID , 
                                                            AccountName = Description, 
                                                            CostAccountID = Account.CostAccountID, Bank = Account.Bank
                                                        });
        }
    }
}
