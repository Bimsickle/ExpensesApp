CREATE PROCEDURE [dbo].[spDuplicateTransaction]
	@id int

AS
begin
	set nocount on;
	
	DECLARE @RecurranceID int = null
	DECLARE @DatePaid date = null
	DECLARE @Confirmed int = null
	DECLARE @Description VARCHAR(50) = null
	DECLARE @DebitID int = null
	DECLARE @CreditID int = null
	DECLARE @Amount decimal(18,4) = null
	select 
	@RecurranceID = RecurranceID, @DatePaid = DatePaid, @Confirmed = Confirmed, @Description = Description, @DebitID=DebitID, @CreditID=CreditID, @Amount =Amount
	from dbo.[Transaction]
	where id = @id;

	INSERT INTO dbo.[Transaction]
	(RecurranceID, DatePaid, Confirmed, Description, DebitID, CreditID, Amount)
	VALUES
	(@RecurranceID, @DatePaid, 0, @Description, @DebitID, @CreditID, @Amount);
	SELECT @@IDENTITY;
end
