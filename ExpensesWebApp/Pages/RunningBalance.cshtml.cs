using ExpensesAppLibrary.Data;
using ExpensesAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.ComponentModel.DataAnnotations;
using System.Globalization;

namespace ExpensesWebApp.Pages
{
    public class RunningBalanceModel : PageModel
    {

        public List<DateOnly> mondays { get; set; }
        [BindProperty(SupportsGet = true), DataType(DataType.Date)]
        public DateTime start { get; set; } = DateTime.Now.AddDays(-14);
        public DateOnly end { get; set; }
        [BindProperty(SupportsGet = true)]
        public int size { get; set; } = 52;
        public List<TransactionModel> transactions { get; set; }
        public List<TransactionModel> balanceTransactions { get; set; }
        public List<List<decimal>> incomeTransactions { get; set; }
        public List<IncomeModel> incomeAccounts { get; set;}
        public List<RecurringExpenseModel> recurringExpenses { get; set; }
        public List<CostAccountModel> bankAccounts    { get; set; }
        //public List<decimal> income { get; set; }
        public List<decimal> incomeBalance { get; set; }
        public List<decimal> bankBalance { get; set; }
        public List<List<decimal>> recurringSpend { get; set;}
        public List<CostAccountModel> costAccount { get; set; }
        public ISqlData _db { get; }

        public RunningBalanceModel(ISqlData db)
        {
            _db = db;
        }
        public void OnGet()
        {
            incomeAccounts = _db.GetIncomeAccounts();
            mondays = new List<DateOnly>();
            incomeTransactions = new List<List<decimal>>();
            recurringSpend = new List<List<decimal>>();
            recurringExpenses = _db.getRecurringExpenseList(active: 1);

            bankBalance = new List<decimal>();
            incomeBalance = new List<decimal>();
            end = CreateWeeks(size);
            for (int i = 0; i < mondays.Count(); i++)
            {
                bankBalance.Add(0);                
            }
            bankAccounts = _db.GetCostAccount("debit");

            //Console.WriteLine(mondays.Count());
            transactions = _db.GetTransactions(end.ToDateTime(TimeOnly.Parse("11:55 PM")), start);
            balanceTransactions = _db.GetTransactions(end.ToDateTime(TimeOnly.Parse("11:55 PM")));
            costAccount = _db.GetCostAccount();

            //int accountnum = 6;
            //GetWeeklySummaries(accountnum);
            //incomeBalance = CreateRunningTotal(accountnum);

            /* Get Balances for Income Accounts */
            foreach (var account in incomeAccounts)
            {
                incomeTransactions.Add(GetWeeklySummaries(account.CostAccountID, account.BankAccountID));
            }
            for (int j = 0; j < mondays.Count; j++)
            {
                decimal bal = 0;
                for (int i = 0; i < incomeAccounts.Count; i++)
                {
                    bal += incomeTransactions[i][j];
                }
                incomeBalance.Add(bal);
                //Console.WriteLine(i);
            }
            foreach (var rec in recurringExpenses)
            {
                recurringSpend.Add(GetWeeklySummaries(rec.CostAccountID, reccur: rec.Id ));
            }
            

            // BANK BALANCES
            for (int i = 0; i < bankAccounts.Count; i++)
            {
                var bal = CreateRunningTotal(bankAccounts[i].CostCentre);
                for (int j = 0; j < bal.Count; j++)
                {
                    bankBalance[j] += bal[j];
                }
            }
        }

        public IActionResult OnPost()
        {            
            return RedirectToPage(new
            {
                size, start = start.ToString("yyyy-MM-dd")
            });
        }
        public DateOnly CreateWeeks(int quantity )
        {
            DateTime monday = start;
            for (int i = 0; i < quantity; i++)
            {
                monday = start.AddDays(1 - (int)start.DayOfWeek+i*7);
                mondays.Add(DateOnly.FromDateTime(monday));
            }
            return DateOnly.FromDateTime(monday.AddDays(6));
        }

        public static int GetWeekOfYear(DateTime time)
        {
            //Iso8601
            DayOfWeek day = CultureInfo.InvariantCulture.Calendar.GetDayOfWeek(time);
            if (day >= DayOfWeek.Monday && day <= DayOfWeek.Wednesday)
            {
                time = time.AddDays(3);
            }
            return CultureInfo.InvariantCulture.Calendar.GetWeekOfYear(time, CalendarWeekRule.FirstFourDayWeek, DayOfWeek.Monday);
        }
        public List<decimal> GetWeeklySummaries(int account, int? other = null, int ? reccur = null)
        {
            List<decimal> income = new List<decimal>();
            var accountFilter_debit = from trans in balanceTransactions where trans.DebitID == account select new { trans.DatePaid, trans.Amount };
            var accountFilter_credit = from trans in balanceTransactions where trans.CreditID == account select new { trans.DatePaid, trans.Amount };
            
            if (other != null)
            {
                accountFilter_debit = from trans in transactions where trans.DebitID ==account && trans.CreditID == other select  new {trans.DatePaid, trans.Amount};
                accountFilter_credit = from trans in transactions where trans.CreditID == account && trans.DebitID ==other  select new {trans.DatePaid, trans.Amount };
            }
            if (reccur != null)
            {
                accountFilter_debit = from trans in transactions where trans.DebitID == account && trans.RecurranceID ==reccur select new { trans.DatePaid, trans.Amount };
                accountFilter_credit = from trans in transactions where trans.CreditID == account && trans.RecurranceID == reccur select new { trans.DatePaid, trans.Amount };
            }

            //Console.WriteLine();
            int debcred=0;
            foreach (CostAccountModel ca in costAccount)
            {
                if (ca.Id == account)
                {
                    debcred = ca.CreditDebit;
                    break;
                }
            }
            foreach (DateOnly day in mondays)
            {
                decimal total = 0;
                var deb = accountFilter_debit.Where(dt => DateOnly.FromDateTime(dt.DatePaid) >= day && DateOnly.FromDateTime(dt.DatePaid) < day.AddDays(7)).Sum(dt=> dt.Amount);
                var cred = accountFilter_credit.Where(dt => DateOnly.FromDateTime(dt.DatePaid) >= day && DateOnly.FromDateTime(dt.DatePaid) < day.AddDays(7)).Sum(dt => dt.Amount);
                total += cred * debcred;
                total -= deb * debcred;
                income.Add(total);
            }
            return income;
        }
        public List<decimal> CreateRunningTotal(int account, int? other = null)
        {
            //Console.WriteLine(end);
            //List<TransactionModel> transAll = _db.GetTransactions(end.ToDateTime(TimeOnly.Parse("11:55 PM")));
            var accountFilter_debit = from trans in balanceTransactions where trans.DebitID == account select new { trans.DatePaid, trans.Amount };
            var accountFilter_credit = from trans in balanceTransactions where trans.CreditID == account select new { trans.DatePaid, trans.Amount };
            if (other != null)
            {
                accountFilter_debit = from trans in transactions where trans.DebitID == account && trans.CreditID == other select new { trans.DatePaid, trans.Amount };
                accountFilter_credit = from trans in transactions where trans.CreditID == account && trans.DebitID == other select new { trans.DatePaid, trans.Amount };
            }
            DateTime min_debDate;
            try
            {
                min_debDate = accountFilter_debit.Min(x => x.DatePaid);
                min_debDate = (min_debDate < start.AddDays(-14) ? min_debDate : start.AddDays(-14));
            }
            catch (Exception ex)
            {
                min_debDate = start.AddDays(-14);
            }
            DateTime min_credDate;
            try
            {
                min_credDate = accountFilter_credit.Min(x => x.DatePaid);
                min_credDate = (min_credDate < start.AddDays(-14) ? min_credDate : start.AddDays(-14));
            }
            catch (Exception ex)
            {
                min_credDate = start.AddDays(-14);
            }

            //var min_credDate = accountFilter_credit.Min(x => x.DatePaid);

            var min_date = (min_debDate< min_credDate ? min_debDate : min_credDate);
            TimeSpan ts = end.ToDateTime(TimeOnly.Parse("11:55 PM")).Subtract(min_date);
            int dateDiff = ts.Days;
            int totalweeks = (int)dateDiff / 7;
            //Console.WriteLine(totalweeks);
            //Console.WriteLine(min_date);
            int debcred = 0;

            foreach (CostAccountModel ca in costAccount)
            {
                if (ca.Id == account)
                {
                    debcred = ca.CreditDebit;
                    break;
                }
            }

            DateTime monday = min_date;

            List<decimal> balance = new List<decimal>();
            List<decimal> runningBalance = new List<decimal>();
            for (int i = 0; i <= totalweeks; i++)
            {
                monday = min_date.AddDays(1 - (int)min_date.DayOfWeek + i * 7);

                //Console.WriteLine(mondays.Any(x=> x == DateOnly.FromDateTime(monday)));
                decimal total = 0;
                var deb = accountFilter_debit.Where(dt => DateOnly.FromDateTime(dt.DatePaid) >= DateOnly.FromDateTime(monday)
                                                          && DateOnly.FromDateTime(dt.DatePaid) < DateOnly.FromDateTime(monday).AddDays(7)).Sum(dt => dt.Amount);
                var cred = accountFilter_credit.Where(dt => DateOnly.FromDateTime(dt.DatePaid) >= DateOnly.FromDateTime(monday)
                                                            && DateOnly.FromDateTime(dt.DatePaid) < DateOnly.FromDateTime(monday).AddDays(7)).Sum(dt => dt.Amount);
                total += cred * debcred;
                total -= deb * debcred;
                if (i == 0)
                {
                    runningBalance.Add(total);
                }
                else
                {
                    runningBalance.Add(total + runningBalance[i - 1]);
                }

                if (mondays.Any(x => x == DateOnly.FromDateTime(monday)))
                {
                    balance.Add(runningBalance[i]);
                }
            }
            return balance;
        }
    }
}
