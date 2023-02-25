CREATE PROCEDURE [dbo].[spRecordTransaction]
		@debit int,
        @credit int,
        @amount decimal(18,4),
        @date date,
        @description VARCHAR(50),
        @reccur int,
        @confirmed int
AS
begin
	set nocount on;

    INSERT INTO dbo.[Transaction] 
        ([DebitID], [CreditID], [Amount], [DatePaid], [Description], [RecurranceID], [Confirmed] )
        VALUES
        (@debit , @credit, @amount, @date, @description, @reccur, @confirmed);
    SELECT @@IDENTITY;
end
