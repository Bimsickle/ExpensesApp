CREATE TABLE [dbo].[BalanceDetails]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Description] VARCHAR(50) NOT NULL, 
    [BalanceGroupId] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[BalanceGroups](Id), 
    [ReccurringId] INT NULL FOREIGN KEY REFERENCES [dbo].[RecurringExpenses](Id), 
    [DebitAccount] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[CostAccount](Id), 
    [CreditAccount] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[CostAccount](Id), 
    [Status] INT NOT NULL DEFAULT 1
)
