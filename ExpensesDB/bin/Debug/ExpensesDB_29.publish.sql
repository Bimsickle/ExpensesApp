﻿/*
Deployment script for Expense

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "Expense"
:setvar DefaultFilePrefix "Expense"
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
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Creating database $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [$(DatabaseName)], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_Primary.mdf')
    LOG ON (NAME = [$(DatabaseName)_log], FILENAME = N'$(DefaultLogPath)$(DefaultFilePrefix)_Primary.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS
GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF),
                MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF,
                DELAYED_DURABILITY = DISABLED 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = ALL, DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_PLANS_PER_QUERY = 200, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE = OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET TEMPORAL_HISTORY_RETENTION ON 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
PRINT N'Creating Table [dbo].[CostAccount]...';


GO
CREATE TABLE [dbo].[CostAccount] (
    [Id]          INT          IDENTITY (1, 1) NOT NULL,
    [Description] VARCHAR (50) NOT NULL,
    [CostCentre]  INT          NOT NULL,
    [Edit]        INT          NOT NULL,
    [Active]      INT          NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Table [dbo].[CostTable]...';


GO
CREATE TABLE [dbo].[CostTable] (
    [Id]          INT          IDENTITY (1, 1) NOT NULL,
    [Account]     VARCHAR (50) NOT NULL,
    [CreditDebit] INT          NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Table [dbo].[CreditAccount]...';


GO
CREATE TABLE [dbo].[CreditAccount] (
    [Id]               INT          IDENTITY (1, 1) NOT NULL,
    [Active]           INT          NOT NULL,
    [Description]      VARCHAR (50) NOT NULL,
    [Bank]             VARCHAR (50) NULL,
    [OpeningDate]      DATE         NULL,
    [Limit]            DECIMAL (18) NOT NULL,
    [MinPayment]       DECIMAL (18) NOT NULL,
    [InterestRate]     DECIMAL (18) NOT NULL,
    [InterestRateCash] DECIMAL (18) NULL,
    [Fee]              DECIMAL (18) NOT NULL,
    [FeeCycleID]       INT          NOT NULL,
    [FeeCycleIncrem]   INT          NOT NULL,
    [CostAccountID]    INT          NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Table [dbo].[DebitAccount]...';


GO
CREATE TABLE [dbo].[DebitAccount] (
    [Id]              INT          IDENTITY (1, 1) NOT NULL,
    [Active]          INT          NOT NULL,
    [Description]     VARCHAR (50) NOT NULL,
    [Bank]            VARCHAR (50) NULL,
    [OpeningDate]     DATE         NULL,
    [InterestRate]    DECIMAL (18) NOT NULL,
    [Fee]             DECIMAL (18) NOT NULL,
    [FeeCycleID]      INT          NOT NULL,
    [FeeCycleIncemum] INT          NOT NULL,
    [CostAccountID]   INT          NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Table [dbo].[Frequency]...';


GO
CREATE TABLE [dbo].[Frequency] (
    [Id]        INT          IDENTITY (1, 1) NOT NULL,
    [Frequency] VARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([Frequency] ASC)
);


GO
PRINT N'Creating Table [dbo].[Income]...';


GO
CREATE TABLE [dbo].[Income] (
    [Id]                   INT          IDENTITY (1, 1) NOT NULL,
    [Description]          VARCHAR (50) NOT NULL,
    [CostAccountID]        INT          NOT NULL,
    [StartDate]            DATE         NULL,
    [EndDate]              DATE         NULL,
    [Active]               INT          NOT NULL,
    [SalaryRate]           DECIMAL (18) NOT NULL,
    [SalaryTaxID]          INT          NOT NULL,
    [TaxHeld]              INT          NOT NULL,
    [SalaryCycleID]        INT          NULL,
    [StandardWeekHours]    DECIMAL (18) NOT NULL,
    [PayCycle]             INT          NULL,
    [PayCycleInrem]        INT          NOT NULL,
    [PayStartDate]         DATE         NULL,
    [PayDayOfWeek]         INT          NOT NULL,
    [WeekendRate]          DECIMAL (18) NOT NULL,
    [HolidayRate]          DECIMAL (18) NOT NULL,
    [EveningRate]          DECIMAL (18) NOT NULL,
    [PaidLeaveHoursAnnual] DECIMAL (18) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Table [dbo].[LoanAccount]...';


GO
CREATE TABLE [dbo].[LoanAccount] (
    [Id]                   INT          IDENTITY (1, 1) NOT NULL,
    [Active]               INT          NOT NULL,
    [ReDraw]               INT          NULL,
    [Description]          VARCHAR (50) NOT NULL,
    [Bank]                 VARCHAR (50) NULL,
    [OpeningDate]          DATE         NULL,
    [ClosingDate]          DATE         NULL,
    [LoanAmount]           DECIMAL (18) NOT NULL,
    [SetupFee]             DECIMAL (18) NOT NULL,
    [RepaymentAmount]      DECIMAL (18) NOT NULL,
    [RepaymentCycleID]     INT          NOT NULL,
    [RepaymentCycleIncrem] INT          NOT NULL,
    [InterestRate]         DECIMAL (18) NOT NULL,
    [InterestFixed]        INT          NOT NULL,
    [Fee]                  DECIMAL (18) NOT NULL,
    [FeeCycleID]           INT          NULL,
    [FeeCycleIncrem]       INT          NULL,
    [CostAccountID]        INT          NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Table [dbo].[RecurringExpenses]...';


GO
CREATE TABLE [dbo].[RecurringExpenses] (
    [Id]                   INT          IDENTITY (1, 1) NOT NULL,
    [Description]          VARCHAR (50) NOT NULL,
    [Active]               INT          NOT NULL,
    [DateStart]            DATE         NOT NULL,
    [DateEnd]              DATE         NULL,
    [CostAccountID]        INT          NOT NULL,
    [FrequencyCycleID]     INT          NOT NULL,
    [FrequencyCycleIncrem] INT          NOT NULL,
    [Amount]               DECIMAL (18) NOT NULL,
    [Increase]             INT          NOT NULL,
    [IncreaseCycleID]      INT          NOT NULL,
    [IncreaseCycleIncrem]  INT          NOT NULL,
    [IncreaseDate]         DATE         NULL,
    [IncreaseType]         INT          NULL,
    [IncreaseAmount]       DECIMAL (18) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Table [dbo].[TaxRate]...';


GO
CREATE TABLE [dbo].[TaxRate] (
    [Id]           INT          IDENTITY (1, 1) NOT NULL,
    [Annual]       DECIMAL (18) NOT NULL,
    [TaxThreshold] DECIMAL (18) NOT NULL,
    [Base]         DECIMAL (18) NOT NULL,
    [TaxPercent]   DECIMAL (18) NOT NULL,
    [MedicareLevy] DECIMAL (18) NOT NULL,
    [HELLP]        DECIMAL (18) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Table [dbo].[Transaction]...';


GO
CREATE TABLE [dbo].[Transaction] (
    [Id]            INT          IDENTITY (1, 1) NOT NULL,
    [DatePaid]      DATE         NOT NULL,
    [Confirmed]     INT          NOT NULL,
    [Description]   VARCHAR (50) NOT NULL,
    [AccountFromID] INT          NOT NULL,
    [AccountToID]   INT          NOT NULL,
    [Amount]        DECIMAL (18) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[CostAccount]...';


GO
ALTER TABLE [dbo].[CostAccount]
    ADD DEFAULT 1 FOR [Edit];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[CostAccount]...';


GO
ALTER TABLE [dbo].[CostAccount]
    ADD DEFAULT 1 FOR [Active];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[CostTable]...';


GO
ALTER TABLE [dbo].[CostTable]
    ADD DEFAULT 1 FOR [CreditDebit];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[CreditAccount]...';


GO
ALTER TABLE [dbo].[CreditAccount]
    ADD DEFAULT 1 FOR [Active];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[CreditAccount]...';


GO
ALTER TABLE [dbo].[CreditAccount]
    ADD DEFAULT 0.0 FOR [Limit];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[CreditAccount]...';


GO
ALTER TABLE [dbo].[CreditAccount]
    ADD DEFAULT 0.0 FOR [MinPayment];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[CreditAccount]...';


GO
ALTER TABLE [dbo].[CreditAccount]
    ADD DEFAULT 0.0 FOR [InterestRate];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[CreditAccount]...';


GO
ALTER TABLE [dbo].[CreditAccount]
    ADD DEFAULT 0.0 FOR [InterestRateCash];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[CreditAccount]...';


GO
ALTER TABLE [dbo].[CreditAccount]
    ADD DEFAULT 0.0 FOR [Fee];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[CreditAccount]...';


GO
ALTER TABLE [dbo].[CreditAccount]
    ADD DEFAULT 1 FOR [FeeCycleID];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[CreditAccount]...';


GO
ALTER TABLE [dbo].[CreditAccount]
    ADD DEFAULT 1 FOR [FeeCycleIncrem];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[DebitAccount]...';


GO
ALTER TABLE [dbo].[DebitAccount]
    ADD DEFAULT 1 FOR [Active];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[DebitAccount]...';


GO
ALTER TABLE [dbo].[DebitAccount]
    ADD DEFAULT 0.0 FOR [InterestRate];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[DebitAccount]...';


GO
ALTER TABLE [dbo].[DebitAccount]
    ADD DEFAULT 0.0 FOR [Fee];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[DebitAccount]...';


GO
ALTER TABLE [dbo].[DebitAccount]
    ADD DEFAULT 1 FOR [FeeCycleID];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[DebitAccount]...';


GO
ALTER TABLE [dbo].[DebitAccount]
    ADD DEFAULT 1 FOR [FeeCycleIncemum];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Income]...';


GO
ALTER TABLE [dbo].[Income]
    ADD DEFAULT 1 FOR [Active];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Income]...';


GO
ALTER TABLE [dbo].[Income]
    ADD DEFAULT 0.00 FOR [SalaryRate];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Income]...';


GO
ALTER TABLE [dbo].[Income]
    ADD DEFAULT 1 FOR [TaxHeld];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Income]...';


GO
ALTER TABLE [dbo].[Income]
    ADD DEFAULT 38 FOR [StandardWeekHours];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Income]...';


GO
ALTER TABLE [dbo].[Income]
    ADD DEFAULT 1 FOR [PayCycleInrem];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Income]...';


GO
ALTER TABLE [dbo].[Income]
    ADD DEFAULT 1 FOR [PayDayOfWeek];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Income]...';


GO
ALTER TABLE [dbo].[Income]
    ADD DEFAULT 1 FOR [WeekendRate];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Income]...';


GO
ALTER TABLE [dbo].[Income]
    ADD DEFAULT 1 FOR [HolidayRate];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Income]...';


GO
ALTER TABLE [dbo].[Income]
    ADD DEFAULT 1 FOR [EveningRate];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Income]...';


GO
ALTER TABLE [dbo].[Income]
    ADD DEFAULT 0.0 FOR [PaidLeaveHoursAnnual];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[LoanAccount]...';


GO
ALTER TABLE [dbo].[LoanAccount]
    ADD DEFAULT 1 FOR [Active];


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
    ADD DEFAULT 0 FOR [Confirmed];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Transaction]...';


GO
ALTER TABLE [dbo].[Transaction]
    ADD DEFAULT 0.0 FOR [Amount];


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[CostAccount]...';


GO
ALTER TABLE [dbo].[CostAccount]
    ADD FOREIGN KEY ([CostCentre]) REFERENCES [dbo].[CostTable] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[CreditAccount]...';


GO
ALTER TABLE [dbo].[CreditAccount]
    ADD FOREIGN KEY ([FeeCycleID]) REFERENCES [dbo].[Frequency] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[CreditAccount]...';


GO
ALTER TABLE [dbo].[CreditAccount]
    ADD FOREIGN KEY ([CostAccountID]) REFERENCES [dbo].[CostAccount] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[DebitAccount]...';


GO
ALTER TABLE [dbo].[DebitAccount]
    ADD FOREIGN KEY ([FeeCycleID]) REFERENCES [dbo].[Frequency] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[DebitAccount]...';


GO
ALTER TABLE [dbo].[DebitAccount]
    ADD FOREIGN KEY ([CostAccountID]) REFERENCES [dbo].[CostAccount] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[Income]...';


GO
ALTER TABLE [dbo].[Income]
    ADD FOREIGN KEY ([CostAccountID]) REFERENCES [dbo].[CostAccount] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[Income]...';


GO
ALTER TABLE [dbo].[Income]
    ADD FOREIGN KEY ([SalaryTaxID]) REFERENCES [dbo].[TaxRate] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[Income]...';


GO
ALTER TABLE [dbo].[Income]
    ADD FOREIGN KEY ([SalaryCycleID]) REFERENCES [dbo].[Frequency] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[Income]...';


GO
ALTER TABLE [dbo].[Income]
    ADD FOREIGN KEY ([PayCycle]) REFERENCES [dbo].[Frequency] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[LoanAccount]...';


GO
ALTER TABLE [dbo].[LoanAccount]
    ADD FOREIGN KEY ([RepaymentCycleID]) REFERENCES [dbo].[Frequency] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[LoanAccount]...';


GO
ALTER TABLE [dbo].[LoanAccount]
    ADD FOREIGN KEY ([FeeCycleID]) REFERENCES [dbo].[Frequency] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[LoanAccount]...';


GO
ALTER TABLE [dbo].[LoanAccount]
    ADD FOREIGN KEY ([CostAccountID]) REFERENCES [dbo].[CostAccount] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[RecurringExpenses]...';


GO
ALTER TABLE [dbo].[RecurringExpenses]
    ADD FOREIGN KEY ([CostAccountID]) REFERENCES [dbo].[CostAccount] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[RecurringExpenses]...';


GO
ALTER TABLE [dbo].[RecurringExpenses]
    ADD FOREIGN KEY ([FrequencyCycleID]) REFERENCES [dbo].[Frequency] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[RecurringExpenses]...';


GO
ALTER TABLE [dbo].[RecurringExpenses]
    ADD FOREIGN KEY ([IncreaseCycleID]) REFERENCES [dbo].[Frequency] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[Transaction]...';


GO
ALTER TABLE [dbo].[Transaction]
    ADD FOREIGN KEY ([AccountFromID]) REFERENCES [dbo].[CostAccount] ([Id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[Transaction]...';


GO
ALTER TABLE [dbo].[Transaction]
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
    ('Interest PaId', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 0);
    
end
/*   

    ('Interest Received', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Revenue'), 0), 
    ('Miscellaneous', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 0),    
    ('Splurge', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 0),
    ('Cash', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Asset'), 0),
    ('Bank Account', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Asset'), 0),
    ('Saving Account', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Asset'), 0),
    ('Credit Account', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Liability'), 0),
    ('Primary Income', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Revenue'), 0),
    ('Other Income', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Revenue'), 0),
    ('Loan Account', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Liability'), 0),
    ('Salary Tax Holding', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Liability'), 0),
    ('Salary Tax PaId', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 0),
    ('Student Loan', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Liability'), 0),
    ('Student Loan PaId', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expense'), 0),
    ('Accommodation', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('Travel Costs', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('Internet', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('Phone', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('Car Insurance', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('Car Registration', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('Healthcare', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('Personal Care', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('Food', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('Education', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('Gifts - Xmas', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('Gifts - Bday', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('Gifts - Other', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('School Fees', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('School Care', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('Sport', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('HolIday', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('Clothing', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('Gas', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('Electricity', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1),
    ('Water', (SELECT Id FROM dbo.[CostTable] WHERE Account = 'Expenses'), 1)
    ;
end
*/
/*
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
    Select @student Id from dbo.[CostAccount] where Description = 'Student Loan';

    INSERT INTO dbo.[LoanAccount]
    ([Description], [CostAccountId])
    VALUES
    ('Primary Loan Account', @loan);

    INSERT INTO dbo.[LoanAccount]
    ([Description], [CostAccountId], [Bank],[ClosingDate], [LoanAmount])
    VALUES
    ('HELLP Loan', @student, 'ATO', '2028-01-01', 18000.00);
end

IF NOT EXISTS (SELECT 1 FROM dbo.[TaxRate])
begin
    INSERT INTO dbo.[TaxRate]
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
    SELECT @tax = a.Id FROM(SELECT Id Id, Min(Annual) Annual from dbo.[TaxRate] WHERE Annual >= @salary group by Id)a;
    SELECT @tax0 = a.Id FROM(SELECT Id Id, Min(Annual) Annual from dbo.[TaxRate] group by Id)a;

    INSERT INTO dbo.[Income]
    ([Description], [CostAccountId], [StartDate], [SalaryRate], [SalaryTaxId], [SalaryCycleId], [PayCycle])
    VALUES
    ('Primary Income', @primary, '2021-11-15', @salary, @tax, @year, @fortnight),
    ('Leon',@other, NULL, @salary0, @tax0, @week,@quarter);
    
end

*/
GO

GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'Update complete.';


GO
