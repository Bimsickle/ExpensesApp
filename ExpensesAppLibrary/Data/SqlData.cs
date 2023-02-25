using ExpensesAppLibrary.Databases;
using ExpensesAppLibrary.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpensesAppLibrary.Data
{
    public class SqlData : ISqlData
    {
        private readonly ISqlDataAccess _db;
        private const string connectionString = "Default";

        public SqlData(ISqlDataAccess db)
        {
            _db = db;
        }
        public List<FrequencyModel> GetFrequencies()
        {
            string sql = "[dbo].[spGetFrequencies]";
            return _db.LoadData<FrequencyModel, dynamic>(sql, new {  }, connectionString, true).ToList();
        }
        public List<IncreaseType> getIncreaseType(int? type= null)
        {
            string sql = "[dbo].[spGetIncreaseType]";
            return _db.LoadData<IncreaseType, dynamic>(sql, new { type }, connectionString, true).ToList();
        }

        /* DEBIT & COST ACCOUNT */
        public DebitAccountModel getDebitAccount(int Id)
        {
            string sql = "[dbo].[spGetDebitAccount]";
            return _db.LoadData<DebitAccountModel, dynamic>(sql, new { Id }, connectionString, true).FirstOrDefault();
        }
        public List<CostAccountModel> GetCostAccount(string? type = null)
        {
            string sql = "dbo.spGetCostAccounts";
            return _db.LoadData<CostAccountModel, dynamic>(sql, new { type }, connectionString, true).ToList();
        }
        public int CreateDebitAccount(string desc, DateTime openDate, decimal rate, decimal fee, int cycle, int increm, string? bank)
        {
            string sql = "[dbo].[spCreateDebitAccount]";
            return _db.CreateData<DebitAccountModel, dynamic>(sql, new { desc, openDate, rate, fee, cycle, increm, bank }, connectionString, true);
        }
        public CostAccountModel GetCostAccountById(int id)
        {
            string sql = "dbo.spGetCostAccountById";
            return _db.LoadData<CostAccountModel, dynamic>(sql, new { id }, connectionString, true).FirstOrDefault();
        }

        /* TRANSACTION STATEMENT */
        public List<TransactionModel> GetTransactions(DateTime endDate, DateTime? startDate = null)
        {
            //string sql = "dbo.spGetTransactions";
            string sql = @"select [Id], [RecurranceID], [DatePaid], [Confirmed], [Description], [DebitID], [CreditID], [Amount] FROM [dbo].[Transaction]
                            where
                            (@startDate IS NULL AND [DatePaid] <= @endDate)
	                        OR
	                        ([DatePaid] >= @startDate AND [DatePaid] <= @endDate)
                            ORDER By[DatePaid], [Description]";
            return _db.LoadData<TransactionModel, dynamic>(sql, new { endDate, startDate }, connectionString);
        }
        public List<TransactionStatement> GetTransactionStatement(DateTime startDate, DateTime endDate, int? Id = null, int ? recurr = null)
        {
            string sql = "dbo.[spGetTransactionStatement]";
            return _db.LoadData<TransactionStatement, dynamic>(sql, new { startDate, endDate , account = @Id, recurr}, connectionString, true);
        }
        public List<TransactionModel> getLatestRecordedRecurringTransaction(int? id= null)
        {
            string sql = "[dbo].[spGetLatestRecordedRecurringTransaction]";
            return _db.LoadData<TransactionModel, dynamic>(sql, new { id }, connectionString, true).ToList();
        }

        /* RECURRING TRANSACTIONS */
        public int CreateRecurringTransaction(string description, decimal amount, int frequencyID, int increm, int costAccountID, int bankAccount, DateTime start, DateTime ? end,
                                                bool ? increase, int ? increaseFrequencyID, DateTime ? increaseDate, int ? increaseType, decimal ? increaseValue, int increaseIncrem)
        {
            string sql = "[dbo].[spAddReccurringExpense]";
            return _db.CreateData<TransactionModel, dynamic>(sql, new { description, amount, frequencyID, increm, costAccountID, bankAccount, start, end,
                                                increase, increaseFrequencyID, increaseDate, increaseType, increaseValue, increaseIncrem }, connectionString, true);
        }
        public int UpdateRecurringTransaction(int id, string description, int active, decimal amount, int frequencyID, int increm, int costAccountID, int bankAccount, DateTime start, DateTime? end,
                                                bool? increase, int? increaseFrequencyID, DateTime? increaseDate, int? increaseType, decimal? increaseValue, int increaseIncrem)
        {
            string sql = "[dbo].[spUpdateRecurring]";
            return _db.CreateData<RecurringExpenseModel, dynamic>(sql, new
            {
                id,
                description,
                active,
                amount,
                frequencyID,
                increm,
                costAccountID,
                bankAccount,
                start,
                end,
                increase,
                increaseFrequencyID,
                increaseDate,
                increaseType,
                increaseValue,
                increaseIncrem
            }, connectionString, true);
        }

        /* RECURRING EXPENSES */
        public void AddRecurringExpense(string description, DateOnly startDate, int costAccount, int paymentAccount, int frequencyCycle, decimal amount, DateOnly? endDate = null)
        {
            string sql = "dbo.spCreateRecurringExpense";
            
            int recordId = _db.CreateData<RecurringExpenseModel, dynamic>(sql, new
            {
                Description = description,
                DateStart = startDate,
                CostAccountID = costAccount,
                DefaultPayAccountID = paymentAccount,
                FrequencyCycleID = frequencyCycle,
                Amount = amount,
                DateEnd = endDate
            }, connectionString, true);

        }
        public List<RecurringExpenseModel> getRecurringExpenseList(int? id = null, int? active = null)
        {
            string sql = "[dbo].[spGetRecurring]";
            return _db.LoadData<RecurringExpenseModel, dynamic>(sql, new { id, active }, connectionString, true).ToList();
        }
       
        /* BANK BALANCES */
        public List<BankBalanceModel> GetBankBalances(DateTime date)
        {
            string sql = "[dbo].[spGetBankAccountBalances]";
            return _db.LoadData<BankBalanceModel, dynamic>(sql, new { date }, connectionString, true).ToList();
        }

        public void AddAccountOpeningBalance(int account, decimal amount, DateTime date)
        {
            string sql = "[dbo].[spSetOpeningBalanceAccount]";
            _db.LoadData<TransactionModel, dynamic>(sql, new { account, amount, date }, connectionString, true);
        }

        /* TRANSACTION */
        public int recordTransaction(int debit, int credit, decimal amount, DateTime date, string description, int confirmed, int ? reccur = null)
        {
            string sql = "[dbo].[spRecordTransaction]";
            return _db.CreateData<TransactionModel, dynamic>(sql, new { debit, credit, amount, date, description, confirmed, reccur }, connectionString, true);
        }
        public int DuplicateTransaction(int id)
        {
            string sql = "[dbo].[spDuplicateTransaction]";
            return _db.CreateData<TransactionModel, dynamic>(sql, new {id }, connectionString, true);
        }
        public TransactionModel getTransaction(int Id)
        {
            string sql = "[dbo].[spGetTransaction]";
            return _db.LoadData<TransactionModel, dynamic>(sql, new { Id }, connectionString, true).FirstOrDefault();
        }
        public void UpdateTransaction(int id, DateTime date, int confirmed, string desc, int debit, int credit, decimal amount, int ? recurr=null)
        {
            string sql = "[dbo].[spUpdateTransaction]";
            _db.CreateData<TransactionModel, dynamic>(sql, new
            {
                id,recurr,date,confirmed,desc,debit,credit,amount
            }, connectionString, true);
        }
        public void DeleteTransaction(int id)
        {
            string sql = "[dbo].[spDeleteTransaction]";
            _db.LoadData<IncomeModel, dynamic>(sql, new{id }, connectionString, true);
        }

        /* RUNNING BALANCE */

        public List<BalanceGroupsModel> GetBalanceGroups()
        {
            string sql = "[dbo].[spGetBalanceGroups]";
            return _db.LoadData<BalanceGroupsModel, dynamic>(sql, new {  }, connectionString, true).ToList();
        }

        public List<BalanceDetailsModel> GetBalanceDetails(int id)
        {
            string sql = "[dbo].[spGetBalanceDetails]";
            return _db.LoadData<BalanceDetailsModel, dynamic>(sql, new { }, connectionString, true).ToList();
        }

        public int AddBalanceDetails(string Description, int DebitAccount, int CreditAccount, int Type, int? BalanceGroupId=null, int? ReccurringId = null)
        {            
            string sql = "[dbo].[spAddBalanceDetails]";
            return _db.CreateData<BalanceDetailsModel, dynamic>(sql, new { Description, DebitAccount, CreditAccount, Type, BalanceGroupId, ReccurringId }, connectionString, true);
        }

        /* INCOME */
        public List<IncomeModel> GetIncomeAccounts(int? id = null)
        {
            string sql = "[dbo].[spGetIncomeAccounts]";
            return _db.LoadData<IncomeModel, dynamic>(sql, new { id }, connectionString, true).ToList();
        }
        public int AddNewIncome(string description,DateTime start,   decimal  salaryrate, bool taxheld, 
                            int salaryCycleID, decimal weekhours, int payCycle, int payCycleIncrem, DateTime payStart, int paydayWeekday, 
                            decimal weekendrate, decimal holidayrate, decimal eveningrate, decimal paidAnnualLeaveHours, int BankAccountID, bool ? studentLoan =null, int ? taxId=null)
        {
            string sql = "[dbo].[spAddNewIncome]";
            return _db.CreateData<IncomeModel, dynamic>(sql, new { description, start, salaryrate,taxheld, 
                                                salaryCycleID, weekhours, payCycle, payCycleIncrem, payStart, paydayWeekday, 
                                                weekendrate, holidayrate, eveningrate, paidAnnualLeaveHours, BankAccountID, studentLoan, taxId }, connectionString, true);
        }

        public void DeleteIncomeAccount(int id)
        {
            string sql = "[dbo].[spDeleteIncomeAccount]";
            _db.LoadData<IncomeModel, dynamic>(sql, new { id }, connectionString, true);
        }
        public void UpdateIncome(int id, string description, int costAccountID, DateTime start, DateTime end, int active, decimal salaryrate, bool taxheld,
                            int salaryCycleID, decimal weekhours, int payCycle, int payCycleIncrem, DateTime payStart, int paydayWeekday,
                            decimal weekendrate, decimal holidayrate, decimal eveningrate, decimal paidAnnualLeaveHours, int BankAccountID, bool studentLoan, int taxId)
        {
            string sql = "[dbo].[spUpdateIncome]";
            _db.CreateData<IncomeModel, dynamic>(sql, new
            {
                id, description,costAccountID, start, end, active,  salaryrate,taxheld, salaryCycleID, weekhours, payCycle, payCycleIncrem, 
                payStart, paydayWeekday, weekendrate, holidayrate, eveningrate, paidAnnualLeaveHours, BankAccountID, taxId
            }, connectionString, true);
        }
        public int GetTaxRate(decimal salary)
        {
            string sql = "[dbo].[spGetTaxBracketID]";
            return _db.CreateData<TaxRateModel, dynamic>(sql, new { salary }, connectionString, true);
        }

        public TaxRateModel getTaxRateDetails(int id)
        {
            string sql = "dbo.spGetTaxBracket";
            return _db.LoadData<TaxRateModel, dynamic>(sql, new { id }, connectionString, true).FirstOrDefault();
        }

        public List<CostAccountModel> getTaxAccounts()
        {
            string sql = "dbo.spGetTaxAccounts";
            return _db.LoadData<CostAccountModel, dynamic>(sql, new {  }, connectionString, true).ToList();
        }

        public LoanModel getEducationLoans()
        {
            string sql = "dbo.spGetEducationLoans";
            return _db.LoadData<LoanModel, dynamic>(sql, new {  }, connectionString, true).FirstOrDefault();
        }
        public int CountStudentLoan()
        {
            string sql = @"select count(id) Loans from dbo.[LoanAccount] WHERE EducationTaxLoan = 1 AND Active = 1";
            return _db.CreateData<TaxRateModel, dynamic>(sql, new {  }, connectionString);
        }

        public TransactionModel GetLatestIncomePayment(int id)
        {
            string sql = "dbo.spGetLatestIncomePayment";
            return _db.LoadData<TransactionModel, dynamic>(sql, new { id }, connectionString, true).FirstOrDefault();
        }
    }

}