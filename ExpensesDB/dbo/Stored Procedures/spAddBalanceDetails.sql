CREATE PROCEDURE [dbo].[spAddBalanceDetails]
	@Description VARCHAR(50),
	@DebitAccount INT,
	@CreditAccount INT,
	@Type int
AS
begin
	set nocount on;
	DECLARE @BalanceGroupId int;
	DECLARE @Id int
	DECLARE @Groupid int

	DECLARE @ReccurringId INT --Optional

	INSERT INTO
	dbo.[BalanceGroups]
	([Description], [Type], [Status]) -- ensure getting Active record
	SELECT DISTINCT @Description, @Type, 1 
	WHERE 1> (SELECT COUNT(*) FROM dbo.[BalanceGroups] WHERE Id = @BalanceGroupId);
	SET @Groupid = (SELECT CASE WHEN @BalanceGroupId IS NULL THEN  @@IDENTITY ELSE @BalanceGroupId end);

	INSERT INTO
	dbo.[BalanceDetails]
	([Description], [BalanceGroupId],[ReccurringId],[DebitAccount],[CreditAccount])
	VALUES 
	(@Description, @Groupid, @ReccurringId, @DebitAccount, @CreditAccount);

	SELECT @Groupid; -- Delete if going ot use below to select new record instead
	
	/*
	--Return Details to Model
	
	set @Id = (select @@IDENTITY);

	select * from 
	dbo.[BalanceDetails]
	WHERE id = @Id;
   */
end
