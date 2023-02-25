CREATE PROCEDURE [dbo].[spGetCostAccounts]
	@type VARCHAR(30)
AS
begin
	set nocount on;
	DECLARE @costType int = (SELECT CASE WHEN @type = 'debit' THEN 1
									WHEN @type = 'income' THEN 6
									WHEN @type = 'expense' THEN 3
									WHEN @type = 'credit' THEN 4
									ELSE -1 END)
	SELECT c.[Id], c.[Description], c.[CostCentre], [Edit], c.[Active], ct.CreditDebit CreditDebit
	FROM dbo.[CostAccount] c

	LEFT JOIN dbo.[CostTable] ct on ct.Id = c.CostCentre
	LEFT JOIN dbo.[DebitAccount] da on da.CostAccountID = c.Id
	LEFT JOIN dbo.[CreditAccount] cred on cred.CostAccountID = c.id
	LEFT JOIN dbo.[LoanAccount] loan on loan.CostAccountID = c.id
	LEFT JOIN dbo.[Income] inc on inc.CostAccountID = c.id

	WHERE c.Active = 1
	AND (@costType = -1 OR CostCentre = @costType)
	AND (CASE WHEN @type = 'debit' THEN da.Id
		WHEN @type = 'loan' THEN loan.id
		WHEN @type = 'credit' THEN cred.Id
		WHEN @type = 'income' THEN inc.Id
		ELSE c.id
		END) IS NOT NULL

	ORDER BY c.Description
end
