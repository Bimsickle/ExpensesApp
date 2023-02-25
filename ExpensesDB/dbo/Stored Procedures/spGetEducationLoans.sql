CREATE PROCEDURE [dbo].[spGetEducationLoans]

AS
begin
	set nocount on;
	SELECT
		*
		FROM [LoanAccount]
		WHERE 
		EducationTaxLoan = 1
		and Active = 1
end
