CREATE TABLE [dbo].[Income]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Description] VARCHAR(50) NOT NULL,
    [CostAccountID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[CostAccount](Id), 
    [StartDate] DATE NULL DEFAULT GETDATE(), 
    [EndDate] DATE NULL, 
    [Active] INT NOT NULL DEFAULT 1,
    [SalaryRate] DECIMAL(18, 4)  NOT NULL DEFAULT 0.00, 
    [SalaryTaxID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[TaxRate](Id), 
    [TaxHeld] INT NOT NULL DEFAULT 1,
    [SalaryCycleID] INT NULL FOREIGN KEY REFERENCES [dbo].[Frequency](Id), 
    [StandardWeekHours] DECIMAL(18, 4)  NOT NULL DEFAULT 38, 
    [PayCycle]  INT NULL FOREIGN KEY REFERENCES [dbo].[Frequency](Id), 
    [PayCycleInrem] INT NOT NULL DEFAULT 1, 
    [PayStartDate] DATE NULL, 
    [PayDayOfWeek] INT NOT NULL DEFAULT 1, 
    [WeekendRate] DECIMAL(18, 4)  NOT NULL DEFAULT 1, 
    [HolidayRate] DECIMAL(18, 4)  NOT NULL DEFAULT 1, 
    [EveningRate] DECIMAL(18, 4)  NOT NULL DEFAULT 1, 
    [PaidLeaveHoursAnnual] DECIMAL(18, 4)  NOT NULL DEFAULT 0.0, 
    [BankAccountID] INT NOT NULL DEFAULT 2, 
    [HoldTaxStudentLoan] INT NULL DEFAULT 0
)
