/*
Deployment script for ExpensesDB

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "ExpensesDB"
:setvar DefaultFilePrefix "ExpensesDB"
:setvar DefaultDataPath "C:\Users\Anj\AppData\Local\Microsoft\VisualStudio\SSDT\"
:setvar DefaultLogPath "C:\Users\Anj\AppData\Local\Microsoft\VisualStudio\SSDT\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Rename refactoring operation with key f7ea3dc3-3d8f-478c-b395-cb82f7f84faa is skipped, element [dbo].[RecurringExpenses].[FrequencyCycle] (SqlSimpleColumn) will not be renamed to FrequencyType';


GO
PRINT N'Rename refactoring operation with key fc482ab5-5294-4c51-a26a-1aee5927a5c9 is skipped, element [dbo].[RecurringExpenses].[FrequencyCycle] (SqlSimpleColumn) will not be renamed to FrequencyCycleIncrem';


GO
PRINT N'Rename refactoring operation with key 2495d677-cc7f-406f-864d-33bba9886c2a is skipped, element [dbo].[RecurringExpenses].[StartDate] (SqlSimpleColumn) will not be renamed to DateStart';


GO
PRINT N'Rename refactoring operation with key 4d72991c-ea79-4345-89f1-0376abd4d876, a41a72bf-61e1-4d0b-ada3-38754908a18c is skipped, element [dbo].[RecurringExpenses].[FrequencyType] (SqlSimpleColumn) will not be renamed to FrequencyCycleID';


GO
PRINT N'Rename refactoring operation with key 2ebbf3eb-746b-47a3-8de5-75a4ebf7652d is skipped, element [dbo].[RecurringExpenses].[IncreaseCycle] (SqlSimpleColumn) will not be renamed to IncreaseCycleID';


GO
PRINT N'Rename refactoring operation with key d70732e8-724a-4bde-9220-570239e1708a, d123a05b-e8a9-4283-b6d2-b16f6fd88a24 is skipped, element [dbo].[CostAccount].[CreditDebit] (SqlSimpleColumn) will not be renamed to CostCentre';


GO
PRINT N'Rename refactoring operation with key e61cdf94-3f39-4c15-b7d0-76af4ae2c10a is skipped, element [dbo].[DebitAccount].[CostAccount] (SqlSimpleColumn) will not be renamed to CostAccountID';


GO
PRINT N'Rename refactoring operation with key 26837c8a-fab4-4770-b8da-2fbeac1fbfbf is skipped, element [dbo].[Transaction].[AccountFrom] (SqlSimpleColumn) will not be renamed to AccountFromID';


GO
PRINT N'Rename refactoring operation with key c1acd5c8-2d8d-40f8-8297-34813340e536 is skipped, element [dbo].[Transaction].[AccountTo] (SqlSimpleColumn) will not be renamed to AccountToID';


GO
PRINT N'Rename refactoring operation with key b47587fc-9f81-4ba4-b21b-42271f5f1f20 is skipped, element [dbo].[Income].[PayRateInc] (SqlSimpleColumn) will not be renamed to SalaryRate';


GO
PRINT N'Rename refactoring operation with key 4d0a6e2b-2ad8-4195-8caf-772e767446eb is skipped, element [dbo].[Income].[PaidSickHours] (SqlSimpleColumn) will not be renamed to PaidSickHoursAnnual';


GO
PRINT N'Rename refactoring operation with key 56d75b61-ca68-45d5-a6cf-0f5eac3601e4 is skipped, element [dbo].[Income].[SalaryTax] (SqlSimpleColumn) will not be renamed to SalaryTaxID';


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[LoanAccount]...';


GO
ALTER TABLE [dbo].[LoanAccount]
    ADD DEFAULT TODAY() FOR [OpeningDate];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[LoanAccount]...';


GO
ALTER TABLE [dbo].[LoanAccount]
    ADD DEFAULT TODAY() FOR [ClosingDate];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[LoanAccount]...';


GO
ALTER TABLE [dbo].[LoanAccount]
    ADD DEFAULT 0.0 FOR [LoanAmount];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[LoanAccount]...';


GO
ALTER TABLE [dbo].[LoanAccount]
    ADD DEFAULT 0.00 FOR [SetupFee];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[LoanAccount]...';


GO
ALTER TABLE [dbo].[LoanAccount]
    ADD DEFAULT 0.0 FOR [RepaymentAmount];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[LoanAccount]...';


GO
ALTER TABLE [dbo].[LoanAccount]
    ADD DEFAULT 1 FOR [RepaymentCycleID];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[LoanAccount]...';


GO
ALTER TABLE [dbo].[LoanAccount]
    ADD DEFAULT 1 FOR [RepaymentCycleIncrem];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[LoanAccount]...';


GO
ALTER TABLE [dbo].[LoanAccount]
    ADD DEFAULT 0.0 FOR [InterestRate];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[LoanAccount]...';


GO
ALTER TABLE [dbo].[LoanAccount]
    ADD DEFAULT 1 FOR [InterestFixed];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[LoanAccount]...';


GO
ALTER TABLE [dbo].[LoanAccount]
    ADD DEFAULT 0.0 FOR [Fee];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[LoanAccount]...';


GO
ALTER TABLE [dbo].[LoanAccount]
    ADD DEFAULT 1 FOR [FeeCycleIncrem];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[RecurringExpenses]...';


GO
ALTER TABLE [dbo].[RecurringExpenses]
    ADD DEFAULT 1 FOR [Active];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[RecurringExpenses]...';


GO
ALTER TABLE [dbo].[RecurringExpenses]
    ADD DEFAULT TODAY() FOR [DateStart];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[RecurringExpenses]...';


GO
ALTER TABLE [dbo].[RecurringExpenses]
    ADD DEFAULT 1 FOR [FrequencyCycleID];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[RecurringExpenses]...';


GO
ALTER TABLE [dbo].[RecurringExpenses]
    ADD DEFAULT 1 FOR [FrequencyCycleIncrem];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[RecurringExpenses]...';


GO
ALTER TABLE [dbo].[RecurringExpenses]
    ADD DEFAULT 0.00 FOR [Amount];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[RecurringExpenses]...';


GO
ALTER TABLE [dbo].[RecurringExpenses]
    ADD DEFAULT 0 FOR [Increase];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[RecurringExpenses]...';


GO
ALTER TABLE [dbo].[RecurringExpenses]
    ADD DEFAULT 1 FOR [IncreaseCycleID];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[RecurringExpenses]...';


GO
ALTER TABLE [dbo].[RecurringExpenses]
    ADD DEFAULT 1 FOR [IncreaseCycleIncrem];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[TaxRate]...';


GO
ALTER TABLE [dbo].[TaxRate]
    ADD DEFAULT 0.0 FOR [Base];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[TaxRate]...';


GO
ALTER TABLE [dbo].[TaxRate]
    ADD DEFAULT .02 FOR [MedicareLevy];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[TaxRate]...';


GO
ALTER TABLE [dbo].[TaxRate]
    ADD DEFAULT 0.04 FOR [HELLP];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Transaction]...';


GO
ALTER TABLE [dbo].[Transaction]
    ADD DEFAULT today() FOR [DatePaid];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Transaction]...';


GO
ALTER TABLE [dbo].[Transaction]
    ADD DEFAULT 0 FOR [Confirmed];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Transaction]...';


GO
ALTER TABLE [dbo].[Transaction]
    ADD DEFAULT 0.0 FOR [Amount];


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[CostAccount]...';


GO
ALTER TABLE [dbo].[CostAccount] WITH NOCHECK
    ADD FOREIGN KEY ([CostCentre]) REFERENCES [dbo].[CostTable] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[CreditAccount]...';


GO
ALTER TABLE [dbo].[CreditAccount] WITH NOCHECK
    ADD FOREIGN KEY ([FeeCycleID]) REFERENCES [dbo].[Frequency] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[CreditAccount]...';


GO
ALTER TABLE [dbo].[CreditAccount] WITH NOCHECK
    ADD FOREIGN KEY ([CostAccountID]) REFERENCES [dbo].[CostAccount] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[DebitAccount]...';


GO
ALTER TABLE [dbo].[DebitAccount] WITH NOCHECK
    ADD FOREIGN KEY ([FeeCycleID]) REFERENCES [dbo].[Frequency] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[DebitAccount]...';


GO
ALTER TABLE [dbo].[DebitAccount] WITH NOCHECK
    ADD FOREIGN KEY ([CostAccountID]) REFERENCES [dbo].[CostAccount] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[Income]...';


GO
ALTER TABLE [dbo].[Income] WITH NOCHECK
    ADD FOREIGN KEY ([CostAccountID]) REFERENCES [dbo].[CostAccount] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[Income]...';


GO
ALTER TABLE [dbo].[Income] WITH NOCHECK
    ADD FOREIGN KEY ([SalaryTaxID]) REFERENCES [dbo].[TaxRate] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[Income]...';


GO
ALTER TABLE [dbo].[Income] WITH NOCHECK
    ADD FOREIGN KEY ([SalaryCycleID]) REFERENCES [dbo].[Frequency] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[Income]...';


GO
ALTER TABLE [dbo].[Income] WITH NOCHECK
    ADD FOREIGN KEY ([PayCycle]) REFERENCES [dbo].[Frequency] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[LoanAccount]...';


GO
ALTER TABLE [dbo].[LoanAccount] WITH NOCHECK
    ADD FOREIGN KEY ([RepaymentCycleID]) REFERENCES [dbo].[Frequency] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[LoanAccount]...';


GO
ALTER TABLE [dbo].[LoanAccount] WITH NOCHECK
    ADD FOREIGN KEY ([FeeCycleID]) REFERENCES [dbo].[Frequency] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[LoanAccount]...';


GO
ALTER TABLE [dbo].[LoanAccount] WITH NOCHECK
    ADD FOREIGN KEY ([CostAccountID]) REFERENCES [dbo].[CostAccount] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[RecurringExpenses]...';


GO
ALTER TABLE [dbo].[RecurringExpenses] WITH NOCHECK
    ADD FOREIGN KEY ([CostAccountID]) REFERENCES [dbo].[CostAccount] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[RecurringExpenses]...';


GO
ALTER TABLE [dbo].[RecurringExpenses] WITH NOCHECK
    ADD FOREIGN KEY ([FrequencyCycleID]) REFERENCES [dbo].[Frequency] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[RecurringExpenses]...';


GO
ALTER TABLE [dbo].[RecurringExpenses] WITH NOCHECK
    ADD FOREIGN KEY ([IncreaseCycleID]) REFERENCES [dbo].[Frequency] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[Transaction]...';


GO
ALTER TABLE [dbo].[Transaction] WITH NOCHECK
    ADD FOREIGN KEY ([AccountFromID]) REFERENCES [dbo].[CostAccount] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[Transaction]...';


GO
ALTER TABLE [dbo].[Transaction] WITH NOCHECK
    ADD FOREIGN KEY ([AccountToID]) REFERENCES [dbo].[CostAccount] ([Id]);


GO
-- Refactoring step to update target server with deployed transaction logs

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '2495d677-cc7f-406f-864d-33bba9886c2a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('2495d677-cc7f-406f-864d-33bba9886c2a')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'f7ea3dc3-3d8f-478c-b395-cb82f7f84faa')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('f7ea3dc3-3d8f-478c-b395-cb82f7f84faa')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'fc482ab5-5294-4c51-a26a-1aee5927a5c9')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('fc482ab5-5294-4c51-a26a-1aee5927a5c9')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '4d72991c-ea79-4345-89f1-0376abd4d876')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('4d72991c-ea79-4345-89f1-0376abd4d876')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'a41a72bf-61e1-4d0b-ada3-38754908a18c')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('a41a72bf-61e1-4d0b-ada3-38754908a18c')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '2ebbf3eb-746b-47a3-8de5-75a4ebf7652d')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('2ebbf3eb-746b-47a3-8de5-75a4ebf7652d')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd70732e8-724a-4bde-9220-570239e1708a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d70732e8-724a-4bde-9220-570239e1708a')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd123a05b-e8a9-4283-b6d2-b16f6fd88a24')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d123a05b-e8a9-4283-b6d2-b16f6fd88a24')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'e61cdf94-3f39-4c15-b7d0-76af4ae2c10a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('e61cdf94-3f39-4c15-b7d0-76af4ae2c10a')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '26837c8a-fab4-4770-b8da-2fbeac1fbfbf')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('26837c8a-fab4-4770-b8da-2fbeac1fbfbf')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'c1acd5c8-2d8d-40f8-8297-34813340e536')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('c1acd5c8-2d8d-40f8-8297-34813340e536')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'b47587fc-9f81-4ba4-b21b-42271f5f1f20')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('b47587fc-9f81-4ba4-b21b-42271f5f1f20')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '4d0a6e2b-2ad8-4195-8caf-772e767446eb')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('4d0a6e2b-2ad8-4195-8caf-772e767446eb')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '56d75b61-ca68-45d5-a6cf-0f5eac3601e4')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('56d75b61-ca68-45d5-a6cf-0f5eac3601e4')

GO

GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
IF NOT EXISTS (SELECT 1 FROM [dbo].[CostTable])
begin
    INSERT INTO [dbo].[CostTable]
    (Account, CreditDebit)
    VALUES
    ('Asset', -1),
    ('Draw',-1),
    ('Expense', -1),
    ('Liability', 1),
    ('Equity', 1),
    ('Revenue', 1);
end

IF NOT EXISTS (SELECT 1 FROM [dbo].[CostAccount])
begin
    INSERT INTO [dbo].[CostAccount]
    ([Description], CostCentre, Edit)
    VALUES
    ('Interest Paid', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expense'), 0),
    ('Interest Received', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Revenue'), 0), 
    ('Miscellaneous', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expense'), 0),    
    ('Splurge', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 0),
    ('Cash', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Asset'), 0),
    ('Bank Account', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Asset'), 0),
    ('Saving Account', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Asset'), 0),
    ('Credit Account', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Liability'), 0),
    ('Primary Income', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Revenue'), 0),
    ('Other Income', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Revenue'), 0),
    ('Loan Account', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Liability'), 0),
    ('Salary Tax Holding', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Liability'), 0),
    ('Salary Tax Paid', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expense'), 0),
    ('Student Loan', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Liability'), 0),
    ('Student Loan Paid', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expense'), 0),
    ('Accommodation', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('Travel Costs', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('Internet', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('Phone', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('Car Insurance', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('Car Registration', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('Healthcare', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('Personal Care', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('Food', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('Education', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('Gifts - Xmas', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('Gifts - Bday', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('Gifts - Other', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('School Fees', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('School Care', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('Sport', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('Holiday', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('Clothing', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('Gas', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('Electricity', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1),
    ('Water', (SELECT ID FROM [dbo].[CostTable] WHERE Account = 'Expenses'), 1)
    ;
end

IF NOT EXISTS (SELECT 1 FROM [dbo].[Frequency])
begin
    INSERT INTO [dbo].[Frequency]
    ([Frequency])
    VALUES
    ('Hourly'),
    ('Daily'),
    ('Weekly'),
    ('Fortnightly'),
    ('Monthly'),
    ('Quarterly'),
    ('Yearly');
end

IF NOT EXISTS (SELECT 1 FROM [dbo].[DebitAccount])
begin
    DECLARE @bank int;
    DECLARE @save int;
    DECLARE @cash int;

    Select @bank = ID from [dbo].[CostAccount] where Description = 'Bank Account';
    Select @save = ID from [dbo].[CostAccount] where Description = 'Saving Account';
    Select @cash = ID from [dbo].[CostAccount] where Description = 'Cash';

    INSERT INTO [dbo].[DebitAccount]
    ([Description], Bank, [CostAccountID])
    VALUES
    ('Primary Bank Account', 'Primary Bank', @bank),
    ('Saving Account', 'Primary Bank', @save),
    ('Cash', NULL, @cash);
end

IF NOT EXISTS (SELECT 1 FROM [dbo].[CreditAccount])
begin
    DECLARE @credit int;
    Select @credit = ID from [dbo].[CostAccount] where Description = 'Credit Account';

    INSERT INTO [dbo].[CreditAccount]
    ([Description], Limit, [CostAccountID])
    VALUES
    ('Primary Credit Account', 0.00, @credit);
end

IF NOT EXISTS (SELECT 1 FROM [dbo].[LoanAccount])
begin
    DECLARE @loan int;
    DECLARE @student int;
    
    Select @loan= ID from [dbo].[CostAccount] where Description = 'Loan Account';
    Select @student ID from [dbo].[CostAccount] where Description = 'Student Loan';

    INSERT INTO [dbo].[LoanAccount]
    ([Description], [CostAccountID])
    VALUES
    ('Primary Loan Account', @loan);

    INSERT INTO [dbo].[LoanAccount]
    ([Description], [CostAccountID], [Bank],[ClosingDate], [LoanAmount])
    VALUES
    ('HELLP Loan', @student, 'ATO', '2028-01-01', 18000.00);
end

IF NOT EXISTS (SELECT 1 FROM [dbo].[TaxRate])
begin
    INSERT INTO [dbo].[TaxRate]
    ([Annual], [TaxThreshold], [Base], [TaxPercent],[HELLP])
    VALUES
    (18201.00, 0.0, 0.0,  0.0, 0.0),
    (45001.00, 18200, 0.0, 0.19, 0.0),

    (53827.00, 45000, 5092.00, 0.325, 0.01),
    (57056.00, 45000, 5092.00, 0.325, 0.02),
    (60480.00, 45000, 5092.00, 0.325, 0.025),
    (64109.00, 45000, 5092.00, 0.325, 0.03),
    (67995.00, 45000, 5092.00, 0.325, 0.035),
    (72032.00, 45000, 5092.00, 0.325, 0.04),
    (76355.00, 45000, 5092.00, 0.325, 0.045),
    (80936.00, 45000, 5092.00, 0.325, 0.05),
    (85793.00, 45000, 5092.00, 0.325, 0.055),
    (90940.00, 45000, 5092.00, 0.325, 0.06),
    (96397.00, 45000, 5092.00, 0.325, 0.065),
    (102180.00, 45000, 5092.00, 0.325, 0.07),
    (108310.00, 45000, 5092.00, 0.325, 0.075),
    (114708.00, 45000, 5092.00, 0.325, 0.08),
    (120001.00, 45000, 5092.00, 0.325, 0.085),

    (121699.00, 120000, 29467.00, 0.37, 0.085),
    (129000.00, 120000, 29467.00, 0.37, 0.09),
    (136740.00, 120000, 29467.00, 0.37, 0.095),

    (180001.00, 120000, 29467.00, 0.37, 0.1),
    (1000000000000.00, 180000.0, 51667.0, 0.45, 0.1);
end

IF NOT EXISTS (SELECT 1 FROM [dbo].[Income])
begin
    DECLARE @week int;
    DECLARE @fortnight int;
    DECLARE @quarter int;
    DECLARE @year int;
    DECLARE @primary int;
    DECLARE @other int;
    DECLARE @salary decimal = 68180;
    DECLARE @tax int;
    DECLARE @salary0 decimal = 52.30;
    DECLARE @tax0 int;

    SELECT @week = ID FROM [dbo].[Frequency] WHERE Frequency = 'Weekly';
    SELECT @fortnight = ID FROM [dbo].[Frequency] WHERE Frequency = 'Fortnightly';
    SELECT @quarter = ID FROM [dbo].[Frequency] WHERE Frequency = 'Quarterly';
    SELECT @year = ID FROM [dbo].[Frequency] WHERE Frequency = 'Yearly';
    Select @primary = ID from [dbo].[CostAccount] where Description = 'Primary Income';
    Select @other = ID from [dbo].[CostAccount] where Description = 'Other Income';
    SELECT @tax = ID FROM(SELECT ID, Min(Annual) Annual from [dbo].[TaxRate] WHERE Annual > @salary)a;
    SELECT @tax0 = ID FROM(SELECT ID, Min(Annual) Annual from [dbo].[TaxRate])a;

    INSERT INTO [dbo].[Income]
    ([Description], [CostAccountID], [StartDate], [SalaryRate], [SalaryTaxID], [SalaryCycleID], [PayCycle])
    VALUES
    ('Primary Income', @primary, '2021-11-15', @salary, @tax, @year, @fortnight),
    ('Leon',@other, NULL, @salary0, @tax0, @week,@quarter);
    
end
GO

GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
CREATE TABLE [#__checkStatus] (
    id           INT            IDENTITY (1, 1) PRIMARY KEY CLUSTERED,
    [Schema]     NVARCHAR (256),
    [Table]      NVARCHAR (256),
    [Constraint] NVARCHAR (256)
);

SET NOCOUNT ON;

DECLARE tableconstraintnames CURSOR LOCAL FORWARD_ONLY
    FOR SELECT SCHEMA_NAME([schema_id]),
               OBJECT_NAME([parent_object_id]),
               [name],
               0
        FROM   [sys].[objects]
        WHERE  [parent_object_id] IN (OBJECT_ID(N'dbo.CostAccount'), OBJECT_ID(N'dbo.CreditAccount'), OBJECT_ID(N'dbo.DebitAccount'), OBJECT_ID(N'dbo.Income'), OBJECT_ID(N'dbo.LoanAccount'), OBJECT_ID(N'dbo.RecurringExpenses'), OBJECT_ID(N'dbo.Transaction'))
               AND [type] IN (N'F', N'C')
                   AND [object_id] IN (SELECT [object_id]
                                       FROM   [sys].[check_constraints]
                                       WHERE  [is_not_trusted] <> 0
                                              AND [is_disabled] = 0
                                       UNION
                                       SELECT [object_id]
                                       FROM   [sys].[foreign_keys]
                                       WHERE  [is_not_trusted] <> 0
                                              AND [is_disabled] = 0);

DECLARE @schemaname AS NVARCHAR (256);

DECLARE @tablename AS NVARCHAR (256);

DECLARE @checkname AS NVARCHAR (256);

DECLARE @is_not_trusted AS INT;

DECLARE @statement AS NVARCHAR (1024);

BEGIN TRY
    OPEN tableconstraintnames;
    FETCH tableconstraintnames INTO @schemaname, @tablename, @checkname, @is_not_trusted;
    WHILE @@fetch_status = 0
        BEGIN
            PRINT N'Checking constraint: ' + @checkname + N' [' + @schemaname + N'].[' + @tablename + N']';
            SET @statement = N'ALTER TABLE [' + @schemaname + N'].[' + @tablename + N'] WITH ' + CASE @is_not_trusted WHEN 0 THEN N'CHECK' ELSE N'NOCHECK' END + N' CHECK CONSTRAINT [' + @checkname + N']';
            BEGIN TRY
                EXECUTE [sp_executesql] @statement;
            END TRY
            BEGIN CATCH
                INSERT  [#__checkStatus] ([Schema], [Table], [Constraint])
                VALUES                  (@schemaname, @tablename, @checkname);
            END CATCH
            FETCH tableconstraintnames INTO @schemaname, @tablename, @checkname, @is_not_trusted;
        END
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH

IF CURSOR_STATUS(N'LOCAL', N'tableconstraintnames') >= 0
    CLOSE tableconstraintnames;

IF CURSOR_STATUS(N'LOCAL', N'tableconstraintnames') = -1
    DEALLOCATE tableconstraintnames;

SELECT N'Constraint verification failed:' + [Schema] + N'.' + [Table] + N',' + [Constraint]
FROM   [#__checkStatus];

IF @@ROWCOUNT > 0
    BEGIN
        DROP TABLE [#__checkStatus];
        RAISERROR (N'An error occurred while verifying constraints', 16, 127);
    END

SET NOCOUNT OFF;

DROP TABLE [#__checkStatus];


GO
PRINT N'Update complete.';


GO
