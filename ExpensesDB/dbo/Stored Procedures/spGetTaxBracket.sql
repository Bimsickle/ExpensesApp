CREATE PROCEDURE [dbo].[spGetTaxBracket]
	@id int
AS
begin
	set nocount on;
	SELECT * 
	from dbo.[TaxRate] 
	where 
	[Id] = @id;
end