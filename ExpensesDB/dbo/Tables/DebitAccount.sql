CREATE TABLE [dbo].[DebitAccount]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Active] INT NOT NULL DEFAULT 1, 
    [Description] VARCHAR(50) NOT NULL, 
    [Bank] VARCHAR(50) NULL, 
    [OpeningDate] DATE NULL  DEFAULT GETDATE(),  
    [InterestRate] DECIMAL(18, 4)  NOT NULL DEFAULT 0.0, 
    [Fee] DECIMAL(18, 4)  NOT NULL DEFAULT 0.0, 
    [FeeCycleID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[Frequency](Id) DEFAULT 1, 
    [FeeCycleIncemum] INT NOT NULL DEFAULT 1, 
    [CostAccountID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[CostAccount](Id)
)
