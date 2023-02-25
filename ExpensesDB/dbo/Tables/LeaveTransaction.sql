CREATE TABLE [dbo].[LeaveTransaction]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [LeaveId] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[LeaveAccount](Id) DEFAULT 1, 
    [Date] DATE NOT NULL DEFAULT GETDATE(), 
    [HoursDebit] DECIMAL(18, 4) NOT NULL DEFAULT 0 , 
    [HoursCredit] DECIMAL(18, 4) NOT NULL DEFAULT 0  
)
