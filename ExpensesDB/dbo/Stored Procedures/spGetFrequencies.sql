CREATE PROCEDURE [dbo].[spGetFrequencies]
	
AS
begin
	set nocount on;
	select [Id], [Frequency] from [dbo].[Frequency]
	order by Id
end
