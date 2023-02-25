CREATE PROCEDURE [dbo].[spSetOpeningBalanceAccount]
		@account int,
		@amount decimal(18,4),
		@date date
		
AS
begin
	set nocount on;
	DECLARE @balanceAccount int = (SELECT Id from [dbo].[CostAccount] where Description = 'Initial Balances')
	DECLARE @cost int = (select costcentre from [dbo].[CostAccount] where Id = @account)
	DECLARE @debit int = (Select case when @cost = 1 then @account else @balanceAccount end)
	DECLARE @credit int = (Select case when @cost = 1 then @balanceAccount else @account end)

	INSERT INTO [dbo].[Transaction] 
	([DatePaid] ,[Confirmed] ,[Description] ,[DebitID] ,[CreditID] , [Amount])
	VALUES
	(@date, 1, 'Opening Balance', @debit, @credit, @amount);
end