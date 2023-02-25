CREATE PROCEDURE [dbo].[spGetCostAccountById]
	@id int
AS
begin
	set nocount on;

	SELECT 
	c.[Id], [Description], [CostCentre], [Edit], [Active] , ct.CreditDebit CreditDebit
	FROM dbo.[CostAccount] c

	LEFT JOIN dbo.[CostTable] ct on ct.Id = c.CostCentre
	WHERE c.Id = @id
end
