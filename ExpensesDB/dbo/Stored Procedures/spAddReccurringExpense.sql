CREATE PROCEDURE [dbo].[spAddReccurringExpense]
	@description VARCHAR(50),
	@start date,
	@end date,
	@costAccountID int,
	@bankAccount int,
	@frequencyID int,
	@increm int,
	@amount decimal(18,4),
	@increase int,
	@increaseFrequencyID int,
	@increaseIncrem int,
	@increaseDate date,
	@increaseType VARCHAR(50), -- % or $
	@increaseValue decimal(18,4)
AS
begin
	set nocount on;

	INSERT INTO dbo.[RecurringExpenses]
	([Description], [Active], [DateStart], [DateEnd], [CostAccountID], [DefaultPayAccountID], 
	[FrequencyCycleID], [FrequencyCycleIncrem], 
	[Amount], 
	[Increase], [IncreaseCycleID], [IncreaseCycleIncrem], [IncreaseDate], [IncreaseType], [IncreaseAmount] )
	VALUES
	(@description, 1, @start, @end, @costAccountID, @bankAccount, 
	@frequencyID, @increm, 
	@amount, 
	@increase, @increaseFrequencyID, @increaseIncrem, @increaseDate, @increaseType, @increaseValue);

	SELECT @@IDENTITY;
end
