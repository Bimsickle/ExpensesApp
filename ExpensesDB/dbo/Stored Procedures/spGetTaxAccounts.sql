CREATE PROCEDURE [dbo].[spGetTaxAccounts]
AS
begin
	set nocount on;
	SELECT
		*
		FROM [dbo].[CostAccount]

		where Edit=0
		AND
		Description LIKE 'Salary Tax%'
end