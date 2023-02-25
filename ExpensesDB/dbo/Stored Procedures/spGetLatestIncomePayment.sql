CREATE PROCEDURE [dbo].[spGetLatestIncomePayment]
	@id int
AS
begin
	set nocount on;
	SELECT 
		DatePaid, SUM(Amount) Amount
		FROM
		[dbo].[Transaction] 
		WHERE
		CreditID = @id

		AND DatePaid = (
			select  MAX(DatePaid) DatePaid
			from [dbo].[Transaction] WHERE CreditID = @id)

		GROUP BY DatePaid;
end
