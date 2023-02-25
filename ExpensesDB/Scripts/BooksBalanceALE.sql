DECLARE @Date Date = '2023-01-08'
DECLARE @Start Date = '2023-01-01'

SELECT * FROM 
(

SELECT 
CASE WHEN CostCentre = 1 THEN 'Debit' ELSE 'Credit' END as Centre, SUM(ISNULL(Credit,0) - ISNULL(Debit,0)) Balance
FROM (

SELECT
ca.[Description], ca.[CostCentre], ct.CreditDebit, ct.Account
,d.Amount * ct.CreditDebit [Debit]
,c.Amount * ct.CreditDebit [Credit]
FROM dbo.[CostAccount] ca
LEFT JOIN dbo.[CostTable] ct on ct.Id = ca.CostCentre
LEFT JOIN (SELECT SUM(Amount) Amount, DebitID FROM dbo.[Transaction] WHERE DatePaid BETWEEN @Start AND @Date GROUP BY DebitID) d on d.DebitID = ca.Id
LEFT JOIN (SELECT SUM(Amount) Amount, CreditID FROM dbo.[Transaction] WHERE DatePaid BETWEEN @Start AND @Date GROUP BY CreditID) c on c.CreditID = ca.Id

WHERE 
ca.CostCentre IN (1,4,5)

--ORDER BY
--CostCentre
) a
GROUP BY CostCentre
)b
PIVOT(
	SUM(Balance) FOR Centre in ([Debit], [Credit])
) p