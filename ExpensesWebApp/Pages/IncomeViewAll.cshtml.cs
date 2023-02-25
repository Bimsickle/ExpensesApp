using ExpensesAppLibrary.Data;
using ExpensesAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace ExpensesWebApp.Pages
{
    public class IncomeViewAllModel : PageModel
    {
        [BindProperty(SupportsGet = true)]
        public int selected { get; set; }
        public List<IncomeModel> IncomeList { get; set; }
        public List<BankBalanceModel> Banks { get; set; }
        public List<FrequencyModel> Frequencies { get; set; }
        public DateTime date { get; set; }= DateTime.Now;
        public ISqlData _db { get; }

        public IncomeViewAllModel(ISqlData db)
        {
            _db = db;
        }
        public void OnGet()
        {
            IncomeList = _db.GetIncomeAccounts();          
        }
        public IActionResult OnPost()
        {
            return RedirectToPage(new
            {

            });
        }
        public string GetBankName(int id)
        {
            Banks = _db.GetBankBalances(date);
            foreach (var bank in Banks)
            {
                if (bank.CostAccountID == id)
                {
                    return bank.AccountName;
                }
            }
            return "";
        }
        public string GetFrequency(int id)
        {
            Frequencies = _db.GetFrequencies();
            foreach (var freq in Frequencies)
            {
                if (freq.Id == id)
                {
                    return freq.Frequency;
                }
            }
            return "";
        }
    }
}
