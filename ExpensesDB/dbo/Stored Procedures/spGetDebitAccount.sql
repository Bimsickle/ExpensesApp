CREATE PROCEDURE [dbo].[spGetDebitAccount]
	@Id int
AS
begin
	set nocount on;
	SELECT 
	[Id], [Active], [Description], [Bank], [OpeningDate], [InterestRate], [Fee], [FeeCycleID], [FeeCycleIncemum], [CostAccountID] 
	FROM dbo.[DebitAccount] 
	where Id = @Id
end