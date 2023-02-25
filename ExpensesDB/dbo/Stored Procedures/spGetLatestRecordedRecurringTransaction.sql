CREATE PROCEDURE [dbo].[spGetLatestRecordedRecurringTransaction]
	@id int
AS
begin
	set nocount on;

	SELECT Max(DatePaid) DatePaid, [RecurranceID]
	FROM dbo.[Transaction]
	WHERE (@id IS NULL OR RecurranceID = @id)
	AND RecurranceID IS NOT NULL
	GROUP BY RecurranceID
end