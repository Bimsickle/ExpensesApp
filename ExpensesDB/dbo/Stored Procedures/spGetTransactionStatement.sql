CREATE PROCEDURE [dbo].[spGetTransactionStatement]
	@startDate date,
	@endDate date,
	@account int,
	@recurr int
AS
begin
	set nocount on;
	select t.[Id], ISNULL(r.Description,'') Recurring, [DatePaid], [Confirmed], t.[Description]
	,case when d.CostCentre =3 then c.Description 
			when d.CostCentre = 1 then c.Description 
			when d.CostCentre = 4 then c.Description
			else d.Description end as AccountFrom
	,case when d.CostCentre =3 then d.Description 
		when d.CostCentre = 1 then d.Description 
		when d.CostCentre = 4 then d.Description
		else '' end as AccountTo
	,case when d.CostCentre =3 then t.[Amount] 
		when d.CostCentre = 1 then 0 
		when c.CostCentre = 6 then 0
		when d.CostCentre = 4 then t.amount 
		else 0 end as MoneyOut
	,case  when d.CostCentre = 1 then t.Amount
		when c.CostCentre = 6 then t.Amount 
		else 0 end as MoneyIn
	,case when d.CostCentre = 1 then 1 when c.CostCentre = 1 then -1 when ca.Id IS NOT NULL THEN -2 end as Highlight


	FROM [dbo].[Transaction] t
	LEFT JOIN [dbo].[CostAccount] d on d.id = t.DebitID
	LEFT JOIN [dbo].[CostAccount] c on c.id = t.CreditID
	LEFT JOIN [dbo].[RecurringExpenses] r on r.Id = t.RecurranceID
	LEFT JOIN [dbo].[CreditAccount] ca on ca.CostAccountID = c.Id

	where [DatePaid] >= @startDate AND [DatePaid] <= @endDate
	AND ((t.DebitID = @account or t.CreditID = @account) or @account is null)
	AND (t.RecurranceID = @recurr or @recurr IS NULL)

	order by DatePaid desc, t.[Description] asc
end