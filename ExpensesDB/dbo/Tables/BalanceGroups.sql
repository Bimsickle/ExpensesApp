﻿CREATE TABLE [dbo].[BalanceGroups]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Description] VARCHAR(50) NOT NULL, 
    [Type] INT NOT NULL DEFAULT 0,
    [Status] INT NOT NULL DEFAULT 1
)
