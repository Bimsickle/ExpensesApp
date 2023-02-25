CREATE PROCEDURE [dbo].[spUpdateRecurring]
	@Id int,
	@description VARCHAR(50),
	@active int,
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

	UPDATE dbo.[RecurringExpenses]
	SET
	[Description] = @description, 
	[Active] = @active, 
	[DateStart] = @start, 
	[DateEnd]= @end, 
	[CostAccountID] = @costAccountID, 
	[DefaultPayAccountID] = @bankAccount, 
	[FrequencyCycleID] = @frequencyID, 
	[FrequencyCycleIncrem] = @increm, 
	[Amount] = @amount, 
	[Increase] = @increase, 
	[IncreaseCycleID] = @increaseFrequencyID, 
	[IncreaseCycleIncrem] = @increaseIncrem, 
	[IncreaseDate] = @increaseDate, 
	[IncreaseType] = @increaseType, 
	[IncreaseAmount] =@increaseValue

	WHERE Id = @Id;
end