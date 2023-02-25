CREATE TABLE [dbo].[Superannuation]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Description] VARCHAR(50) NOT NULL, 
    [SuperAccount] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[CostAccount](Id),
    [IncomeAccount] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[CostAccount](Id),      
    [InterestAccount] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[CostAccount](Id), 
    [ExpenseAccount] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[CostAccount](Id), 
    [AccountStatus] INT NOT NULL DEFAULT 1
)
