CREATE TABLE [dbo].[RecurringExpenses]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Description] VARCHAR(50) NOT NULL,
    [Active] INT NOT NULL DEFAULT 1, 
    [DateStart] DATE NOT NULL DEFAULT GETDATE(), 
    [DateEnd] DATE NULL, 
    [CostAccountID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[CostAccount](Id),
    [DefaultPayAccountID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[CostAccount](Id),
    [FrequencyCycleID] INT NOT NULL DEFAULT 1 FOREIGN KEY REFERENCES [dbo].[Frequency](Id), 
    [FrequencyCycleIncrem] INT NOT NULL DEFAULT 1, 
    [Amount] DECIMAL(18, 4)  NOT NULL DEFAULT 0.00, 
    [Increase] INT NOT NULL DEFAULT 0, 
    [IncreaseCycleID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[Frequency](Id) DEFAULT 1, 
    [IncreaseCycleIncrem] INT NOT NULL DEFAULT 1, 
    [IncreaseDate] DATE NULL, 
    [IncreaseType] INT NULL, 
    [IncreaseAmount] DECIMAL(18, 4)  NULL 
)
