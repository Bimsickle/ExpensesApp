CREATE PROCEDURE [dbo].[spGetBalanceDetails]
	@id int
AS
begin
	set nocount on;
	select * from [dbo].[BalanceDetails]
	where @id = [BalanceGroupId]
	AND [Status] = 1;
end
