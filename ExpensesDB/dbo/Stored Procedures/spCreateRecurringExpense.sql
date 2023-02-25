CREATE PROCEDURE [dbo].[spCreateRecurringExpense]
	@description varchar(50), 
	@startDate date, 
	@costAccount int, 
	@paymentAccount int,
	@frequencyCycle int,
	@amount decimal,
	@endDate date
AS
begin
	set nocount on;
	INSERT INTO [dbo].[RecurringExpenses]
	([Description], [DateStart],[CostAccountID], [DefaultPayAccountID], [FrequencyCycleID], [Amount], [DateEnd] )
	VALUES
	(@description, @startDate, @costAccount, @paymentAccount, @frequencyCycle, @amount, @endDate);

	SELECT @@IDENTITY;
end
