CREATE TABLE [dbo].[Transaction]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [RecurranceID] INT NULL FOREIGN KEY REFERENCES [dbo].[RecurringExpenses](Id), 
    [DatePaid] DATE NOT NULL  DEFAULT GETDATE(), 
    [Confirmed] INT NOT NULL DEFAULT 0, 
    [Description] VARCHAR(50) NOT NULL, 
    [DebitID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[CostAccount](Id), 
    [CreditID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[CostAccount](Id), 
    [Amount] DECIMAL(18, 4)  NOT NULL DEFAULT 0.0
)
