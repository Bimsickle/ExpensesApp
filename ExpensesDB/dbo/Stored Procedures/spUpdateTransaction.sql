CREATE PROCEDURE [dbo].[spUpdateTransaction]
	@id int,
	@recurr int,
	@date date,
	@confirmed int ,
	@desc VARCHAR(50) ,
	@debit int,
	@credit int,
	@amount DECIMAL(18,4) 

AS
begin
	set nocount on;
	UPDATE [dbo].[Transaction]
	SET 	
		[RecurranceID] =@recurr, 
		[DatePaid] =@date, 
		[Confirmed] =@confirmed, 
		[Description] =@desc, 
		[DebitID] =@debit, 
		[CreditID] =@credit, 
		[Amount] =@amount
	WHERE [Id] =@id;

end