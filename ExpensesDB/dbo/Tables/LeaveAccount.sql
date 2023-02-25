CREATE TABLE [dbo].[LeaveAccount]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Status] INT NOT NULL DEFAULT 1,
    [Type] VARCHAR(50) NOT NULL DEFAULT 'Annual', 
    [Paid] INT NOT NULL DEFAULT 1, 
    [IncomeId] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[Income](Id), 
    [StartDate] DATE NOT NULL DEFAULT GETDATE(), 
    [PayableOnExit] INT NOT NULL DEFAULT 1, 
    [TotalEarned] DECIMAL(18, 4) NOT NULL DEFAULT 1, 
    [TotalType] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[Frequency](Id) DEFAULT 1, 
    [AccrualPeriod] DECIMAL(18, 4) NOT NULL DEFAULT 1, 
    [AccrualType] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[Frequency](Id) DEFAULT 7, 
    [HourRate] DECIMAL(18, 4) NOT NULL DEFAULT 0
)
