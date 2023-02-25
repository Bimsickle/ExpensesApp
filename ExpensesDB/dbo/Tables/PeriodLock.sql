﻿CREATE TABLE [dbo].[PeriodLock]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [StartDate] DATE NOT NULL, 
    [EndDate] DATE NOT NULL, 
    [Asset] DECIMAL(18, 4) NOT NULL DEFAULT 0, 
    [Draw] DECIMAL(18, 4) NOT NULL DEFAULT 0, 
    [Expense] DECIMAL(18, 4) NOT NULL DEFAULT 0, 
    [Liability] DECIMAL(18, 4) NOT NULL DEFAULT 0, 
    [Equity] DECIMAL(18, 4) NOT NULL DEFAULT 0, 
    [Revenue] DECIMAL(18, 4) NOT NULL DEFAULT 0, 
    [Balance] DECIMAL(18, 4) NOT NULL DEFAULT 0, 
    [Net] DECIMAL(18, 4) NOT NULL DEFAULT 0, 
    [Status] INT NOT NULL DEFAULT 0, 
    [DateClosed] DATE NOT NULL DEFAULT getdate()
)