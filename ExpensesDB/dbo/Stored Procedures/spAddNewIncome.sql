CREATE PROCEDURE [dbo].[spAddNewIncome]
	@description varchar(50),
	--@costAccountID int,
	@start Date,
	--@end date ,
	--@active int,
	@salaryrate decimal(18,4),
	@taxId int,
	@taxheld int,
	@salaryCycleID int,
	@weekhours decimal(18,4),
	@payCycle int,
	@payCycleIncrem int,
	@payStart date,
	@paydayWeekday int,
	@weekendrate decimal(18,4),
	@holidayrate decimal(18,4),
	@eveningrate decimal(18,4),
	@paidAnnualLeaveHours decimal (18,4),
	@BankAccountID int,
	@studentLoan int

AS
begin
	set nocount on;
	-- Assume Salary Cycle is annual if tax rate is null for SalaryRate
	DECLARE @taxCalcRate int;
	SELECT @taxCalcRate =
		CASE WHEN @taxId IS NULL THEN ( SELECT Id from dbo.[TaxRate] where Annual = (SELECT Min(Annual) Annual from dbo.[TaxRate] WHERE Annual > @salaryrate))
		ELSE @taxId END ;

	/* GET New Cost Account ID */
	DECLARE @costAccountID int;
	INSERT INTO [dbo].[CostAccount]
	([Description], [Active],[CostCentre],[Edit])
	VALUES
	(@description, 1, 6, 0);
	SELECT  @@IDENTITY;
	SELECT @costAccountID = @@IDENTITY;

	/* Create new income */
	INSERT INTO dbo.Income
	([Description] , [CostAccountID], [StartDate],  [Active], [SalaryRate], [SalaryTaxID], [TaxHeld], [SalaryCycleID], 
	[StandardWeekHours], [PayCycle], [PayCycleInrem], [PayStartDate], [PayDayOfWeek], [WeekendRate], [HolidayRate], [EveningRate], 
	[PaidLeaveHoursAnnual], [BankAccountID], [HoldTaxStudentLoan] )
	VALUES
	(@description, @costAccountID, @start,  1, @salaryrate,@taxCalcRate, @taxheld, @salaryCycleID ,
	@weekhours ,@payCycle , @payCycleIncrem , @payStart , @paydayWeekday ,@weekendrate ,@holidayrate ,@eveningrate ,
	@paidAnnualLeaveHours, @BankAccountID, @studentLoan );
	
	SELECT @@IDENTITY;
	
end