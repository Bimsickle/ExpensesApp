CREATE PROCEDURE [dbo].[spGetTransactions]
	--@startDate date, 
	@endDate date
AS
begin
	DECLARE @startDate date;
	select [Id], [RecurranceID], [DatePaid], [Confirmed], [Description], [DebitID], [CreditID], [Amount] FROM [dbo].[Transaction]
	where
	(@startDate IS NULL AND [DatePaid] <= @endDate)
	OR
	([DatePaid] >= @startDate AND [DatePaid] <= @endDate)
	ORDER By [DatePaid], [Description]
end
