CREATE PROCEDURE [dbo].[spGetIncreaseType]
	@type int
AS
begin
	set nocount on;
	SELECT * FROM dbo.[IncreaseType]

	WHERE (@type IS NULL OR Id = @type)
end
