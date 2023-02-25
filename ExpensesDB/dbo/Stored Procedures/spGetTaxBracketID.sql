CREATE PROCEDURE [dbo].[spGetTaxBracketID]
	@income int
AS
begin
	set nocount on;
	SELECT Id 
	from dbo.[TaxRate] 
	where 
	Annual = (SELECT Min(Annual) Annual from dbo.[TaxRate] WHERE Annual > @income);
end