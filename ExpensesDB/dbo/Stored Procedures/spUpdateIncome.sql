CREATE PROCEDURE [dbo].[spUpdateIncome]
	@id int,
	@description varchar(50),
	@costAccountID int,
	@start Date,
	@end date ,
	@active int,
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

	UPDATE dbo.Income
	SET
	[Description] =@description, 
	[CostAccountID]=@costAccountID, 
	[StartDate]=@start, 
	[EndDate]=@end, 
	[Active]=@active, 
	[SalaryRate]=@salaryrate, 
	[SalaryTaxID]=@taxCalcRate, 
	[TaxHeld]=@taxheld, 
	[SalaryCycleID]=@salaryCycleID, 
	[StandardWeekHours]=@weekhours, 
	[PayCycle]=@payCycle, 
	[PayCycleInrem]=@payCycleIncrem, 
	[PayStartDate]=@payStart, 
	[PayDayOfWeek]=@paydayWeekday, 
	[WeekendRate]=@weekendrate, 
	[HolidayRate]=@holidayrate, 
	[EveningRate]=@eveningrate, 
	[PaidLeaveHoursAnnual]=@paidAnnualLeaveHours, 
	[BankAccountID] = @BankAccountID,
	[HoldTaxStudentLoan] = @studentLoan
	WHERE
	Id = @id;
	
end
