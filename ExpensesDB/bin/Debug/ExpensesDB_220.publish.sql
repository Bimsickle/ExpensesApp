﻿/*
Deployment script for Expenses

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "Expenses"
:setvar DefaultFilePrefix "Expenses"
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
PRINT N'Dropping Default Constraint unnamed constraint on [dbo].[BalanceDetails]...';


GO
ALTER TABLE [dbo].[BalanceDetails] DROP CONSTRAINT [DF__BalanceDe__Statu__5B78929E];


GO
PRINT N'Dropping Default Constraint unnamed constraint on [dbo].[TaxRate]...';


GO
ALTER TABLE [dbo].[TaxRate] DROP CONSTRAINT [DF__TaxRate__Medicar__5A846E65];


GO
PRINT N'Dropping Foreign Key unnamed constraint on [dbo].[BalanceDetails]...';


GO
ALTER TABLE [dbo].[BalanceDetails] DROP CONSTRAINT [FK__BalanceDe__Balan__5E54FF49];


GO
PRINT N'Dropping Foreign Key unnamed constraint on [dbo].[BalanceDetails]...';


GO
ALTER TABLE [dbo].[BalanceDetails] DROP CONSTRAINT [FK__BalanceDe__Recur__5F492382];


GO
PRINT N'Dropping Foreign Key unnamed constraint on [dbo].[BalanceDetails]...';


GO
ALTER TABLE [dbo].[BalanceDetails] DROP CONSTRAINT [FK__BalanceDe__Debit__603D47BB];


GO
PRINT N'Dropping Foreign Key unnamed constraint on [dbo].[BalanceDetails]...';


GO
ALTER TABLE [dbo].[BalanceDetails] DROP CONSTRAINT [FK__BalanceDe__Credi__61316BF4];


GO
PRINT N'Starting rebuilding table [dbo].[BalanceDetails]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_BalanceDetails] (
    [Id]             INT          IDENTITY (1, 1) NOT NULL,
    [Description]    VARCHAR (50) NOT NULL,
    [BalanceGroupId] INT          NOT NULL,
    [RecurringId]    INT          NULL,
    [DebitAccount]   INT          NOT NULL,
    [CreditAccount]  INT          NOT NULL,
    [Status]         INT          DEFAULT 1 NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[BalanceDetails])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_BalanceDetails] ON;
        INSERT INTO [dbo].[tmp_ms_xx_BalanceDetails] ([Id], [Description], [BalanceGroupId], [RecurringId], [DebitAccount], [CreditAccount], [Status])
        SELECT   [Id],
                 [Description],
                 [BalanceGroupId],
                 [RecurringId],
                 [DebitAccount],
                 [CreditAccount],
                 [Status]
        FROM     [dbo].[BalanceDetails]
        ORDER BY [Id] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_BalanceDetails] OFF;
    END

DROP TABLE [dbo].[BalanceDetails];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_BalanceDetails]', N'BalanceDetails';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[TaxRate]...';


GO
ALTER TABLE [dbo].[TaxRate]
    ADD DEFAULT .02 FOR [MedicareLevy];


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[BalanceDetails]...';


GO
ALTER TABLE [dbo].[BalanceDetails] WITH NOCHECK
    ADD FOREIGN KEY ([BalanceGroupId]) REFERENCES [dbo].[BalanceGroups] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[BalanceDetails]...';


GO
ALTER TABLE [dbo].[BalanceDetails] WITH NOCHECK
    ADD FOREIGN KEY ([RecurringId]) REFERENCES [dbo].[RecurringExpenses] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[BalanceDetails]...';


GO
ALTER TABLE [dbo].[BalanceDetails] WITH NOCHECK
    ADD FOREIGN KEY ([DebitAccount]) REFERENCES [dbo].[CostAccount] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[BalanceDetails]...';


GO
ALTER TABLE [dbo].[BalanceDetails] WITH NOCHECK
    ADD FOREIGN KEY ([CreditAccount]) REFERENCES [dbo].[CostAccount] ([Id]);


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
IF NOT EXISTS (SELECT 1 FROM dbo.[CostTable])
begin
    INSERT INTO dbo.[CostTable]
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
    ('Cash', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Asset'), 0),
    ('Bank Account', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Asset'), 0),
    ('Saving Account', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Asset'), 0),
    ('Credit Account', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Liability'), 0),
    ('Primary Income', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Revenue'), 0),
    ('Other Income', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Revenue'), 0),
    ('Loan Account', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Liability'), 0),
    ('Superannuation Account', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Asset'), 0),
    ('Superannuation Interest', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Revenue'), 0),
    ('Superannuation Expense', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 0),
    ('Home Loan Account', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Liability'), 0),
    ('Home Loan Interest Account', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Liability'), 0),
    ('Home Loan Expense', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 0), 
    ('Home Loan Interest Expense', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 0), 
    ('Salary Tax Holding', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Liability'), 0),
    ('Salary Tax Income', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Revenue'), 0),
    ('Salary Tax Paid', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 0),
    ('Student Loan', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Liability'), 0),
    ('Student Loan Paid', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 0),
    ('Interest Paid', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 0), 
    ('Interest Received', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Revenue'), 0), 
    ('Bank Fees', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 0),
    ('Initial Balances', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 0), 
    ('Miscellaneous', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 0),    
    ('Splurge', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 0),
    ('Accommodation', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('Travel Costs', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('Internet', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('Phone', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('Car Insurance', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('Car Registration', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('Healthcare', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('Personal Care', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('Food', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('Education', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('Gifts - Xmas', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('Gifts - Bday', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('Gifts - Other', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('School Fees', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('School Care', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('Sport', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('Holiday', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('Clothing', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('Gas', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('Electricity', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1),
    ('Water', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 1)
    ;
end

IF NOT EXISTS (SELECT 1 FROM dbo.[Frequency])
begin
    INSERT INTO dbo.[Frequency]
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

IF NOT EXISTS (SELECT 1 FROM dbo.[DebitAccount])
begin
    DECLARE @bank int;
    DECLARE @save int;
    DECLARE @cash int;

    Select @bank = Id from dbo.[CostAccount] where Description = 'Bank Account';
    Select @save = Id from dbo.[CostAccount] where Description = 'Saving Account';
    Select @cash = Id from dbo.[CostAccount] where Description = 'Cash';

    INSERT INTO dbo.[DebitAccount]
    ([Description], Bank, [CostAccountId])
    VALUES
    ('Primary Bank Account', 'Primary Bank', @bank),
    ('Saving Account', 'Primary Bank', @save),
    ('Cash', NULL, @cash);
end

IF NOT EXISTS (SELECT 1 FROM dbo.[CreditAccount])
begin
    DECLARE @credit int;
    Select @credit = Id from dbo.[CostAccount] where Description = 'Credit Account';

    INSERT INTO dbo.[CreditAccount]
    ([Description], Limit, [CostAccountId])
    VALUES
    ('Primary Credit Account', 0.00, @credit);
end

IF NOT EXISTS (SELECT 1 FROM dbo.[LoanAccount])
begin
    DECLARE @loan int;
    DECLARE @student int;
    
    Select @loan= Id from dbo.[CostAccount] where Description = 'Loan Account';
    Select @student = Id from dbo.[CostAccount] where Description = 'Student Loan';

    INSERT INTO dbo.[LoanAccount]
    ([Description], [CostAccountId], [ClosingDate], [InterestCostAccountID],[EducationTaxLoan])
    VALUES
    ('Primary Loan Account', @loan, '2023-08-22', @loan,0);

    INSERT INTO dbo.[LoanAccount]
    ([Description], [CostAccountId], [Bank],[ClosingDate], [LoanAmount], [InterestCostAccountID],[EducationTaxLoan])
    VALUES
    ('HELLP Loan', @student, 'ATO', '2028-01-01', 18000.00, @student,1);
end

IF NOT EXISTS (SELECT 1 FROM dbo.[TaxRate])
begin
    -- 2023 AU FY
    INSERT INTO dbo.[TaxRate]
    ([Annual], [TaxThreshold], [Base], [TaxPercent],[HELLP])
    VALUES
    (18201.00, 0.0, 0.0,  0.0, 0.0),
    (45001.00, 18200, 0.0, 0.19, 0.0),
    -- Breaks for HEX/HELLP Indexing
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
    -- Breaks for HEX/HELLP Indexing
    (121699.00, 120000, 29467.00, 0.37, 0.085),
    (129000.00, 120000, 29467.00, 0.37, 0.09),
    (136740.00, 120000, 29467.00, 0.37, 0.095),
    -- Breaks for HEX/HELLP Indexing
    (180001.00, 120000, 29467.00, 0.37, 0.1),
    (1000000000000.00, 180000.0, 51667.0, 0.45, 0.1);
end

IF NOT EXISTS (SELECT 1 FROM dbo.[Income])
begin
    DECLARE @week int;
    DECLARE @fortnight int;
    DECLARE @quarter int;
    DECLARE @year int;
    DECLARE @primary int;
    DECLARE @other int;
    DECLARE @salary decimal = 68180.00;
    DECLARE @tax int;
    DECLARE @salary0 decimal = 52.30;
    DECLARE @tax0 int;

    SELECT @week = Id FROM dbo.[Frequency] WHERE Frequency = 'Weekly';
    SELECT @fortnight = Id FROM dbo.[Frequency] WHERE Frequency = 'Fortnightly';
    SELECT @quarter = Id FROM dbo.[Frequency] WHERE Frequency = 'Quarterly';
    SELECT @year = Id FROM dbo.[Frequency] WHERE Frequency = 'Yearly';
    Select @primary = Id from dbo.[CostAccount] where Description = 'Primary Income';
    Select @other = Id from dbo.[CostAccount] where Description = 'Other Income';
    SELECT @tax = Id from dbo.[TaxRate] where Annual = (SELECT Min(Annual) Annual from dbo.[TaxRate] WHERE Annual > @salary);
    SELECT @tax0 = Id from dbo.[TaxRate] where Annual = (SELECT Min(Annual) Annual from dbo.[TaxRate] );

    INSERT INTO dbo.[Income]
    ([Description], [CostAccountId], [StartDate], [SalaryRate], [SalaryTaxId], [SalaryCycleId], [PayCycle])
    VALUES
    ('Primary Income', @primary, '2021-11-15', @salary, @tax, @year, @fortnight),
    ('Leon',@other, NULL, @salary0, @tax0, @week,@quarter);    
end

IF NOT EXISTS (SELECT 1 FROM [dbo].[RecurringExpenses])
begin
    DECLARE @accom int;
    DECLARE @bankt int;
    DECLARE @monthly int;

    SELECT @monthly = Id FROM dbo.[Frequency] WHERE Frequency = 'Monthly';
    SELECT @accom = Id from [dbo].[CostAccount] WHERE [Description] = 'Accommodation';
    SELECT @bankt = Id from [dbo].[CostAccount] WHERE [Description] = 'Bank Account';

    INSERT INTO 
    [dbo].[RecurringExpenses] 
    ([Description], [Active], [DateStart], [DateEnd], [CostAccountID], [DefaultPayAccountID], [FrequencyCycleID], [FrequencyCycleIncrem], [Amount]) 
    VALUES ( N'Rent - Real Estate', 1, DATEADD(day,-2,GETDATE()), NULL, @accom, @bankt, @monthly, 1, CAST(1716.0000 AS Decimal(18, 4)))
end

IF NOT EXISTS (SELECT 1 FROM dbo.[Transaction])
begin
    DECLARE @balInit int;
    DECLARE @salTax int;
    --DECLARE @bankt int;
    DECLARE @loant int;
    DECLARE @creditt int;
    DECLARE @primaryt int;
    DECLARE @salaryt int;
    DECLARE @studLoan int;
    DECLARE @studPaid int;
    DECLARE @taxHold int;
    DECLARE @rego int;
    --DECLARE @accom int;
    DECLARE @recur int;

    SELECT @balInit = Id from [dbo].[CostAccount] WHERE [Description] = 'Initial Balances';
    SELECT @salTax = Id from [dbo].[CostAccount] WHERE [Description] = 'Salary Tax Income';
    SELECT @bankt = Id from [dbo].[CostAccount] WHERE [Description] = 'Bank Account';
    SELECT @loant = Id from [dbo].[CostAccount] WHERE [Description] = 'Loan Account';
    SELECT @creditt = Id from [dbo].[CostAccount] WHERE [Description] = 'Credit Account';
    SELECT @primaryt = Id from [dbo].[CostAccount] WHERE [Description] = 'Primary Income';
    SELECT @salaryt = Id from [dbo].[CostAccount] WHERE [Description] = 'Salary Tax Paid';
    SELECT @studLoan = Id from [dbo].[CostAccount] WHERE [Description] = 'Student Loan';
    SELECT @taxHold = Id from [dbo].[CostAccount] WHERE [Description] = 'Salary Tax Holding';
    SELECT @rego = Id from [dbo].[CostAccount] WHERE [Description] = 'Car Insurance';
    SELECT @accom = Id from [dbo].[CostAccount] WHERE [Description] = 'Accommodation';
    SELECT @studPaid = Id from [dbo].[CostAccount] WHERE [Description] = 'Education'; 
    SELECT @recur = Id from [dbo].[RecurringExpenses]  WHERE [Description] = 'Rent - Real Estate';

    INSERT INTO [dbo].[Transaction] 
    ([DatePaid], [Confirmed], [Description], [DebitID], [CreditID], [Amount], [RecurranceID]) 
    VALUES 
    (DATEADD(day,1,GETDATE()), 1, N'Loan Balance', @balInit, @loant, CAST(5000.0000 AS Decimal(18, 4)), NULL),
    (DATEADD(day,8,GETDATE()), 1, N'New Units', @studPaid, @studLoan, CAST(2004.0000 AS Decimal(18, 4)), NULL),
    (DATEADD(day,8,GETDATE()), 1, N'Maths', @studPaid, @studLoan, CAST(494.2200 AS Decimal(18, 4)), NULL),
    (DATEADD(day,2,GETDATE()), 1, N'New Credit Card', @balInit, @creditt, CAST(6000.0000 AS Decimal(18, 4)), NULL),
    (DATEADD(day,2,GETDATE()), 1, N'New Credit Card', @creditt, @bankt, CAST(116.7800 AS Decimal(18, 4)), NULL),
    (DATEADD(day,2,GETDATE()), 1, N'Test Transaction', @loan, @balInit, CAST(2360.8100 AS Decimal(18, 4)), NULL),
    (DATEADD(day,12,GETDATE()), 0, N'Salary', @bankt, @primaryt, CAST(1982.5200 AS Decimal(18, 4)), NULL),
    (DATEADD(day,12,GETDATE()), 0, N'Tax', @taxHold, @salTax, CAST(628.0000 AS Decimal(18, 4)), NULL),
    (DATEADD(day,12,GETDATE()), 0, N'Tax Paid on Salary', @salaryt, @taxHold, CAST(523.5792 AS Decimal(18, 4)), NULL),
    (DATEADD(day,12,GETDATE()), 0, N'Salaray Paid on Hellp', @studLoan, @taxHold, CAST(104.4208 AS Decimal(18, 4)), NULL),
    (DATEADD(day,-3,GETDATE()), 0, N'Salary', @bankt, @primaryt, CAST(1982.5200 AS Decimal(18, 4)), NULL),
    (DATEADD(day,-3,GETDATE()), 0, N'Tax', @taxHold, @salTax, CAST(628.0000 AS Decimal(18, 4)), NULL),
    (DATEADD(day,-3,GETDATE()), 0, N'Tax Paid on Salary', @salaryt, @taxHold, CAST(523.5792 AS Decimal(18, 4)), NULL),
    (DATEADD(day,-3,GETDATE()), 0, N'Salaray Paid on Hellp', @studLoan, @taxHold, CAST(104.4208 AS Decimal(18, 4)), NULL),
    (GETDATE(), 1, N'Hellp Loan Initial', @balInit, @taxHold, CAST(18000.0000 AS Decimal(18, 4)), NULL),
    (GETDATE(), 1, N'Hellp Income', @taxHold, @primaryt, CAST(18000.0000 AS Decimal(18, 4)), NULL),
    (DATEADD(day,1,GETDATE()), 1, N'Hellp Loan', @studPaid, @studLoan, CAST(18000.0000 AS Decimal(18, 4)), NULL),
    (DATEADD(day,1,GETDATE()), 1, N'Paid an expenses', @rego, @creditt, CAST(58.2200 AS Decimal(18, 4)), NULL),
    (DATEADD(day,-2,GETDATE()), 1, N'Rent', @accom, @bankt, CAST(1716.0000 AS Decimal(18, 4)), @recur) 
end

IF NOT EXISTS (SELECT 1 FROM [dbo].[WeekDates])
begin
    DECLARE @StartDate Date = cast (DATEADD(wk, DATEDIFF(wk,0,DATEADD(week,-3,GETDATE())), 0) as date)
    INSERT INTO [dbo].[WeekDates]
    ([StartWeek], [EndWeek])
    VALUES
    (@StartDate, DATEADD(day,6,@StartDate)),
    (DATEADD(day,7,@StartDate), DATEADD(day,6,@StartDate)),
    (DATEADD(day,14,@StartDate), DATEADD(day,20,@StartDate)),
    (DATEADD(day,21,@StartDate), DATEADD(day,27,@StartDate)),
    (DATEADD(day,28,@StartDate), DATEADD(day,34,@StartDate)),
    (DATEADD(day,35,@StartDate), DATEADD(day,41,@StartDate)),
    (DATEADD(day,42,@StartDate), DATEADD(day,48,@StartDate)),
    (DATEADD(day,49,@StartDate), DATEADD(day,55,@StartDate)),
    (DATEADD(day,56,@StartDate), DATEADD(day,62,@StartDate)),
    (DATEADD(day,63,@StartDate), DATEADD(day,69,@StartDate)),
    (DATEADD(day,70,@StartDate), DATEADD(day,76,@StartDate)),
    (DATEADD(day,77,@StartDate), DATEADD(day,83,@StartDate)),
    (DATEADD(day,84,@StartDate), DATEADD(day,90,@StartDate)),
    (DATEADD(day,91,@StartDate), DATEADD(day,97,@StartDate)),
    (DATEADD(day,98,@StartDate), DATEADD(day,104,@StartDate));
end

IF NOT EXISTS (SELECT 1 FROM [dbo].[IncreaseType])
BEGIN
    INSERT INTO [dbo].[IncreaseType] ([Id], [Type]) VALUES (1, N'Fixed Value $')
    INSERT INTO [dbo].[IncreaseType] ([Id], [Type]) VALUES (2, N'Percentage %')
END
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
        WHERE  [parent_object_id] IN (OBJECT_ID(N'dbo.BalanceDetails'))
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
