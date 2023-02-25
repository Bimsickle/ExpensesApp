CREATE PROCEDURE [dbo].[spGetTransaction]
	@id int

AS
begin
	set nocount on;

	select 
	[Id], [RecurranceID], [DatePaid], [Confirmed], [Description], [DebitID], [CreditID], [Amount]
	from dbo.[Transaction]
	where id = @id;

end
