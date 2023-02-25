DECLARE @Date Date = '2023-01-4';
DECLARE @Start Date = '2023-01-01';
DECLARE @Lock int;
--SET @Start = (select DATEADD(Day, 1, MAX([EndDate])) [StartDate] from dbo.[PeriodLock]);
SELECT @Start, @Date


insert into dbo.[PeriodLock]
([startDate], [EndDate], [Asset], [Draw], [Expense], [Liability], [Equity], [Net], [Status], [DateClosed])
VALUES
(@Start, @Date, 0,0,0,0,0,0,1,getdate());

SET @Lock = @@IDENTITY;

--SET @Start = (select DATEADD(Day, 1, MAX([EndDate])) [StartDate] from dbo.[PeriodLock])
--SELECT @Start
--select top 2 *  from dbo.[AccountLockBalance]

--select * from dbo.[CostAccount]

INSERT INTO dbo.[AccountLockBalance]
([LockID], [DateBalanced], [Account], [CostCentre], [Balance])--*/
/*
(SELECT 1 Lock, '2022-12-31', Id, CostCentre, 0 Balance
from dbo.[CostAccount])*/
(
select  
@Lock,  @Date Date, ca.id Account,  ca.CostCentre ,SUM((ISNULL(c.Amount,0)*ct.CreditDebit)-(ISNULL(d.Amount,0)*ct.CreditDebit))+ISNULL(prev.Balance,0) Balance
from dbo.[CostAccount] ca

LEFT JOIN dbo.[CostTable] ct on ct.id = ca.CostCentre
LEFT JOIN (SELECT Sum(Amount) Amount, DebitID FROM dbo.[Transaction] WHERE DatePaid BETWEEN @Start AND  @Date GROUP By DebitID) d on d.DebitID = ca.Id
LEFT JOIN (SELECT SUm(Amount) Amount, CreditID FROM dbo.[Transaction] WHERE DatePaid BETWEEN @Start AND  @Date GROUP By CreditID) c on c.CreditID = ca.Id
LEFT JOIN (SELECT acl.Account, SUM(Balance) Balance, DateBalanced FROM dbo.AccountLockBalance acl
			LEFT JOIN (SELECT
						Account, Max(DateBalanced) MaxDate
						FROM dbo.AccountLockBalance
						GROUP By Account) da on da.Account = acl.Account 
			group by acl.Account, DateBalanced, MaxDate
			HAVING DateBalanced = MaxDate
			) prev on prev.Account = ca.Id

GROUP BY 
ca.id, ca.Description, ca.CostCentre, ct.Account, ct.CreditDebit
,ISNULL(prev.Balance,0));


MERGE dbo.[PeriodLock] AS pl 
USING(SELECT * FROM (

		SELECT LockID,Id, ISNULL(bal.Balance,0) Balance from dbo.[CostTable] ct
		LEFT JOIN (
		select LockID,CostCentre, SUM(Balance) Balance from dbo.[AccountLockBalance]
		where LockID = @Lock
		GROUP By LockID,CostCentre) bal on bal.CostCentre = ct.Id
		--ORDER BY Id
		WHERE LockID IS NOT NULL
		)a
		PIVOT (
			SUM(a.Balance) FOR Id in ([1],[2], [3], [4], [5], [6])
		) AS p) AS b   
on b.LockID = pl.Id
WHEN MATCHED THEN
UPDATE SET 
pl.Asset = ISNULL(b.[1],0),
pl.Draw = ISNULL(b.[2],0),
pl.Expense = ISNULL(b.[3],0),
pl.[Liability] = ISNULL(b.[4],0),
pl.[Equity] = ISNULL(b.[5],0),
pl.[Revenue] = ISNULL(b.[6],0),
pl.[Balance] = ISNULL(b.[1],0) - (ISNULL(b.[4],0)+ISNULL(b.[5],0)), -- Balance Sheet
--pl.[Net] = ISNULL(b.[6],0)-ISNULL(b.[3],0)-ISNULL(b.[2],0); -- P&L
pl.[Net] = ISNULL(b.[1],0)-ISNULL(b.[4],0); -- Actual NET

select *  from dbo.[AccountLockBalance] WHERE LockID = @Lock