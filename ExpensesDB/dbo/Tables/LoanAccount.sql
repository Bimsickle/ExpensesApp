CREATE TABLE [dbo].[LoanAccount]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY,
	[Active] INT NOT NULL DEFAULT 1, 
    [ReDraw] INT NULL,
    [Description] VARCHAR(50) NOT NULL, 
    [Bank] VARCHAR(50) NULL, 
    [OpeningDate] DATE NULL  DEFAULT GETDATE(), 
    [ClosingDate] DATE NULL ,
    [LoanAmount] DECIMAL(18, 4)  NOT NULL DEFAULT 0.0, 
    [SetupFee] DECIMAL(18, 4)  NOT NULL Default 0.00,
    [RepaymentAmount] DECIMAL(18, 4)  NOT NULL DEFAULT 0.0, 
    [RepaymentCycleID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[Frequency](Id) DEFAULT 1, 
    [RepaymentCycleIncrem] INT NOT NULL DEFAULT 1,
    [InterestRate] DECIMAL(18, 4)  NOT NULL DEFAULT 0.0, 
    [InterestFixed] INT NOT NULL DEFAULT 1,
    [Fee] DECIMAL(18, 4)  NOT NULL DEFAULT 0.0, 
    [FeeCycleID] INT NULL FOREIGN KEY REFERENCES [dbo].[Frequency](Id), 
    [FeeCycleIncrem] INT NULL DEFAULT 1,
    [CostAccountID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[CostAccount](Id),
    [InterestCostAccountID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[CostAccount](Id), 
    [EducationTaxLoan] INT NULL DEFAULT 0
)
