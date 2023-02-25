CREATE PROCEDURE [dbo].[spGetRecurring]
	@id int,
	@active int
AS
begin
	set nocount on;

	SELECT [Id], [Description], [Active], [DateStart], [DateEnd], [CostAccountID], [DefaultPayAccountID], [FrequencyCycleID], [FrequencyCycleIncrem], [Amount], [Increase], [IncreaseCycleID], [IncreaseCycleIncrem], [IncreaseDate], [IncreaseType], [IncreaseAmount] 
	,latest.DatePaid LatestRecord
	FROM dbo.[RecurringExpenses] re

	LEFt JOIN (SELECT Max(DatePaid) DatePaid, [RecurranceID]
	FROM dbo.[Transaction]
	WHERE (@id IS NULL OR RecurranceID = @id)
	AND RecurranceID IS NOT NULL
	GROUP BY RecurranceID) latest ON latest.RecurranceID = re.Id

	WHERE (@id IS NULL OR Id = @id)
	AND (@active IS NULL OR Active = @active)
	ORDER BY active DESC, Description ASC
end
