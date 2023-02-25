CREATE TABLE [dbo].[CostAccount]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Description] VARCHAR(50) NOT NULL, 
    [CostCentre] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[CostTable](Id), 
    [Edit] INT NOT NULL DEFAULT 1, 
    [Active] INT NULL DEFAULT 1
)
