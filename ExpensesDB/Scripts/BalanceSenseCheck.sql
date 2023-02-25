select
--DebitCost,CreditCost,

sum(case when DebitCost in (1,2,3) then debit else 0 end + case  when CreditCost in (1,2,3) then credit else 0 end) as debits
,sum(case when DebitCost not in (1,2,3) then debit else 0 end + case when CreditCost not in (1,2,3) then credit else 0 end) as credits
from
(
select t.Amount, t.Description, d.Description debtdesc, d.CostCentre DebitCost, c.Description Creddec, c.CostCentre CreditCost, dt.CreditDebit*-1*t.Amount Debit , t.Amount*ct.CreditDebit Credit
--,case when d.CostCentre IN (1,2,3) then  t.Amount else t.amount *-1 end as Debits
--,case when c.CostCentre IN (4,5,6) then  t.Amount else t.amount *-1 end as Credits
from dbo.[Transaction] t
left join dbo.[CostAccount] c on c.id = t.CreditID
left join dbo.[costtable] ct on ct.id = c.CostCentre
left join dbo.[CostAccount] d on d.id = t.DebitID
left join dbo.[costtable] dt on dt.id = d.CostCentre
)a 

--group by DebitCost, CreditCost