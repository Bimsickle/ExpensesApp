CREATE TABLE [dbo].[AccountLockBalance]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [LockID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[PeriodLock](Id), 
    [DateBalanced] DATE NOT NULL, 
    [Account] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[CostAccount](Id), 
    [CostCentre] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[CostTable](Id), 
    [Balance] DECIMAL(18, 4) NOT NULL
)
