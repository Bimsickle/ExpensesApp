CREATE PROCEDURE [dbo].[spCreateDebitAccount]
	@desc varchar(50),
	@bank varchar(50),
	@openDate date,
	@rate decimal(18,4),
	@fee decimal(18,4),
	@cycle int,
	@increm int
	

AS
begin
	set nocount on;
	
	-- Create Cos account locked and linked to Bank account
	INSERT INTO dbo.[CostAccount] (Description, CostCentre, Edit) VALUES (@desc, 1, 0);
	declare @account int
	SELECT @account = @@IDENTITY;
	-- Use cost account ID to set up new Bank Account
	INSERT INTO dbo.[DebitAccount] (Description, Bank, OpeningDate, InterestRate, Fee, FeeCycleID, FeeCycleIncemum, CostAccountID)
			VALUES (@desc, @bank, @openDate, @rate, @fee, @cycle, @increm, @account)
	;SELECT @@IDENTITY
end
