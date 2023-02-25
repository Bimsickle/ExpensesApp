CREATE PROCEDURE [dbo].[spDeleteTransaction]
	@id int
AS
begin
	set nocount on;
	DELETE FROM dbo.[Transaction] WHERE Id = @id;
end
