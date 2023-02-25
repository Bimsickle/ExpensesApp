CREATE PROCEDURE [dbo].[spGetBankAccountBalances]
	@date Date 
AS
begin
	set nocount on;
	select 
		da.Id, 
		CostAccountID, 
		da.Description AccountName, 
		Bank, 
		'Debit' Account, 
		NULL Limit, 
		((isnull(c.amount,0) * ct.CreditDebit) - (isnull(d.amount,0) * ct.CreditDebit)) Balance,
		((isnull(c.amount,0) * ct.CreditDebit) - (isnull(d.amount,0) * ct.CreditDebit)) AvailableBalance
		,1 sort

	from dbo.[DebitAccount]  da
	LEFT JOIN dbo.[CostAccount] cost on cost.Id = da.CostAccountID
	LEFT JOIN dbo.[CostTable] ct on ct.id = cost.CostCentre
	LEFT JOIN (select SUM(isnull(Amount,0)) amount, CreditID from dbo.[Transaction] t
		where DatePaid <= @date group by CreditID) c on c.CreditID = da.CostAccountID
	LEFT JOIN (select SUM(isnull(Amount,0)) amount, DebitID from dbo.[Transaction] t
		where DatePaid <= @date group by DebitID) d on d.DebitID = da.CostAccountID

	where da.Active = 1

	UNION

	select 
		ca.Id, 
		CostAccountID, 
		ca.Description AccountName, 
		Bank, 
		'Credit' Account, 
		Limit, 
		-1*((isnull(c.amount,0) * ct.CreditDebit) - (isnull(d.amount,0) * ct.CreditDebit))  Balance,
		Limit -((isnull(c.amount,0) * ct.CreditDebit) - (isnull(d.amount,0) * ct.CreditDebit))  AvailableBalance
		,2 sort

	from dbo.[CreditAccount] ca
	LEFT JOIN dbo.[CostAccount] cost on cost.Id = ca.CostAccountID
	LEFT JOIN dbo.[CostTable] ct on ct.id = cost.CostCentre
	LEFT JOIN (select SUM(isnull(Amount,0)) amount, CreditID from dbo.[Transaction] t
		where DatePaid <= @date group by CreditID) c on c.CreditID = ca.CostAccountID
	LEFT JOIN (select SUM(isnull(Amount,0)) amount, DebitID from dbo.[Transaction] t
		where DatePaid <= @date group by DebitID) d on d.DebitID = ca.CostAccountID

	where ca.Active = 1

	UNION
	select 
		la.Id, 
		CostAccountID, 
		la.Description AccountName, 
		Bank, 
		'Loan' Account, 
		NULL Limit, 
		-1*((isnull(c.amount,0) * ct.CreditDebit) - (isnull(d.amount,0) * ct.CreditDebit))  Balance,
		0  AvailableBalance
		,3 sort

	from dbo.[LoanAccount] la
	LEFT JOIN dbo.[CostAccount] cost on cost.Id = la.CostAccountID
	LEFT JOIN dbo.[CostTable] ct on ct.id = cost.CostCentre

	LEFT JOIN (select SUM(isnull(Amount,0)) amount, CreditID from dbo.[Transaction] t
		where DatePaid <= @date group by CreditID) c on c.CreditID = la.CostAccountID

	LEFT JOIN (select SUM(isnull(Amount,0)) amount, DebitID from dbo.[Transaction] t
		where DatePaid <= @date group by DebitID) d on d.DebitID = la.CostAccountID

	where la.Active = 1

	UNION
	SELECT th.Id, th.Id, th.Description, 'ATO' Bank, 'Tax Holding' Account, Null Limit, 
		-1*((isnull(c.amount,0) * ct.CreditDebit) - (isnull(d.amount,0) * ct.CreditDebit))  Balance, 0 AvailableBalance, 4 sort 
		FROM [dbo].[CostAccount] th

		LEFT JOIN dbo.[CostAccount] cost on cost.Id = th.id
	LEFT JOIN dbo.[CostTable] ct on ct.id = cost.CostCentre

		LEFT JOIN (select SUM(isnull(Amount,0)) amount, CreditID from dbo.[Transaction] t
		where DatePaid <= @date group by CreditID) c on c.CreditID = th.id

		LEFT JOIN (select SUM(isnull(Amount,0)) amount, DebitID from dbo.[Transaction] t
		where DatePaid <= @date group by DebitID) d on d.DebitID = th.id

		where th.Edit=0
		AND
		th.Description LIKE 'Salary Tax%'
		AND
		th.CostCentre = 4

	order by sort, Balance Desc, AccountName asc

end
