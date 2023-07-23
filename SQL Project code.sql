
select * from Orders;
select * from segment_scores;
-----Calculate RFM-------
WITH RFM_VALUE
AS (
select [customer id],
[customer name],
DATEDIFF(day,max([order date]),CONVERT(date,GETDATE())) as Recency_Value, --Recency value (R) is got from the last purchase(order date)
COUNT(distinct [Order Date]) as Frequency_Value,--Frequency value (F): total number of transactions
ROUND(SUM(sales),2) as Monetary_Value --Monetary value (M): total moneny spent
from Orders
group by [customer id], [Customer Name])
--select * from RFM_VALUE
, RFM_TABLE
AS (
select *,
NTILE(5) OVER (ORDER BY Recency_Value DESC) as R_Score, --the longer the customers returns, the less value it brings
NTILE(5) OVER (ORDER BY Frequency_Value ASC) as F_Score,
NTILE(5) OVER (ORDER BY Monetary_Value ASC) as M_Score
from RFM_VALUE )
--select * from RFM_TABLE
, RFM
AS (
select *,
CONCAT(R_Score,F_Score,M_Score) as RFM_Scores
from RFM_TABLE)
--select * from RFM
select RFM.*,seg.Segment
from RFM join segment_scores seg on RFM.RFM_Scores = seg.Scores