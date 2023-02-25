using ExpensesAppLibrary.Models;

namespace ExpensesAppLibrary.Data
{
    public interface ISqlData
    {
        void AddAccountOpeningBalance(int account, decimal amount, DateTime date);
        int AddBalanceDetails(string Description, int DebitAccount, int CreditAccount, int Type, int? BalanceGroupId = null, int? ReccurringId = null);
        int AddNewIncome(string description, DateTime start, decimal salaryrate, bool taxheld, int salaryCycleID, decimal weekhours, int payCycle, int payCycleIncrem, DateTime payStart, int paydayWeekday, decimal weekendrate, decimal holidayrate, decimal eveningrate, decimal paidAnnualLeaveHours, int BankAccountID, bool ? studentLoan = null, int? taxId = null);
        void AddRecurringExpense(string description, DateOnly startDate, int costAccount, int paymentAccount, int frequencyCycle, decimal amount, DateOnly? endDate = null);
        int CountStudentLoan();
        int CreateDebitAccount(string desc, DateTime openDate, decimal rate, decimal fee, int cycle, int increm, string? bank);
        int CreateRecurringTransaction(string description, decimal amount, int frequencyID, int increm, int costAccountID, int bankAccount, DateTime start, DateTime? end, bool? increase, int? increaseFrequencyID, DateTime? increaseDate, int? increaseType, decimal? increaseValue, int increaseIncrem);
        void DeleteIncomeAccount(int id);
        void DeleteTransaction(int id);
        int DuplicateTransaction(int id);
        List<BalanceDetailsModel> GetBalanceDetails(int id);
        List<BalanceGroupsModel> GetBalanceGroups();
        List<BankBalanceModel> GetBankBalances(DateTime date);
        List<CostAccountModel> GetCostAccount(string? type = null);
        CostAccountModel GetCostAccountById(int id);
        DebitAccountModel getDebitAccount(int Id);
        LoanModel getEducationLoans();
        List<FrequencyModel> GetFrequencies();
        List<IncomeModel> GetIncomeAccounts(int? id = null);
        List<IncreaseType> getIncreaseType(int ? type=null);
        TransactionModel GetLatestIncomePayment(int id);
        List<TransactionModel> getLatestRecordedRecurringTransaction(int? id= null);
        List<RecurringExpenseModel> getRecurringExpenseList(int? id = null, int? active = null);
        List<CostAccountModel> getTaxAccounts();
        int GetTaxRate(decimal salary);
        TaxRateModel getTaxRateDetails(int id);
        TransactionModel getTransaction(int Id);
        List<TransactionModel> GetTransactions(DateTime endDate, DateTime ? startDate = null);
        List<TransactionStatement> GetTransactionStatement(DateTime startDate, DateTime endDate, int? Id = null, int ? recurr = null);
        int recordTransaction(int debit, int credit, decimal amount, DateTime date, string description, int confirmed, int? reccur = null);
        void UpdateIncome(int id, string description, int costAccountID, DateTime start, DateTime end, int active, decimal salaryrate, bool taxheld, int salaryCycleID, decimal weekhours, int payCycle, int payCycleIncrem, DateTime payStart, int paydayWeekday, decimal weekendrate, decimal holidayrate, decimal eveningrate, decimal paidAnnualLeaveHours, int BankAccountID, bool studentLoan, int taxId);
        int UpdateRecurringTransaction(int id, string description, int active, decimal amount, int frequencyID, int increm, int costAccountID, int bankAccount, DateTime start, DateTime? end, bool? increase, int? increaseFrequencyID, DateTime? increaseDate, int? increaseType, decimal? increaseValue, int increaseIncrem);
        void UpdateTransaction(int id, DateTime date, int confirmed, string desc, int debit, int credit, decimal amount, int? recurr=null);
    }
}