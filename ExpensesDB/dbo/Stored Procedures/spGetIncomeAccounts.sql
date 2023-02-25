CREATE PROCEDURE [dbo].[spGetIncomeAccounts]
	@id int
AS
begin
	set nocount on;

	SELECT i.Id, i.Active, i.Description, i.StartDate, i.EndDate, i.SalaryRate, i.SalaryCycleID, i.BankAccountID , c.LastPayDate, c.LastPayAmount, i.CostAccountID, 
	i.StandardWeekHours, i.PayCycle, i.SalaryTaxID, i.HoldTaxStudentLoan, i.PayCycleInrem, i.PayDayOfWeek, i.TaxHeld
	FROM [dbo].[Income] i 

	LEFT JOIN ( SELECT a.CreditID, a.DatePaid LastPayDate, Sum(b.Amount) LastPayAmount
			from ( SELECT max(DatePaid) DatePaid, CreditID from [dbo].[Transaction]  WHERE DatePaid<=Getdate() and Confirmed=1 group by CreditID) a

	LEFT JOIN (SELECT CreditID, DatePaid, Amount  
				from [dbo].[Transaction] )b on b.DatePaid = a.DatePaid and a.CreditID = b.CreditID
				group by a.DatePaid, a.CreditID )c on c.CreditID = i.CostAccountID

	LEFT JOIN DebitAccount da on da.CostAccountID = i.BankAccountID

	WHERE i.Id = @id or  @id IS NULL;
end