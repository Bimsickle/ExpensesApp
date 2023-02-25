CREATE PROCEDURE [dbo].[spDeleteIncomeAccount]
	@Id int
AS
begin
	set nocount on;
	DECLARE @account int;
	DECLARE @transactions int;

	SET @account = (Select CostAccountID from dbo.[Income] WHERE Id = @Id)

	SET @transactions = (select Count(c.Id) Transactions from dbo.[Income] i
							LEFT JOIN dbo.[Transaction] d on d.DebitID = i.CostAccountID
							LEFT JOIN dbo.[Transaction] c on c.CreditID = i.CostAccountID
							where i.id = @Id);
	/* Delete if no trnasactions recorded */
	DELETE FROM dbo.[Income] WHERE Id = @Id AND @transactions =0;

	/* Set Income and cost account to inactive if transactions found */
	UPDATE dbo.[Income] 
	SET Active = 0
	WHERE Id = @Id AND @transactions > 0;

	UPDATE dbo.[CostAccount]
	SET Active = 0
	WHERE Id = @account AND @transactions > 0;
end
