CREATE PROCEDURE [dbo].[spGetBalanceGroups]

AS
begin
	set nocount on;
	DECLARE @Id int;

	select * from [dbo].[BalanceGroups]
	where (@id IS NULL OR Id = @Id);
end
