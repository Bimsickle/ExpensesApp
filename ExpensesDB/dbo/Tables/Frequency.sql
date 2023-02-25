CREATE TABLE [dbo].[Frequency]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Frequency] VARCHAR(50) NOT NULL ,
    UNIQUE([Frequency])
)
