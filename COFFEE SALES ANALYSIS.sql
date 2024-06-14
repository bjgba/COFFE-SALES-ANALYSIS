select *
from coffee


alter table coffee
alter column transaction_date date


alter table coffee
alter column transaction_time time

select distinct(datename(month,transaction_date))
from coffee


---total sales 
select round(sum(unit_price*transaction_qty),2)
from coffee

---MOM unit price DIFFERENCE
with cte as (
select cast(sum(unit_price*transaction_qty) as decimal(10,2)) as mtdtotalsales,(select cast(sum(unit_price*transaction_qty) as decimal(10,2)) from coffee where datepart(MONTH,transaction_date)=4) as ptmdtotalsales
from coffee
where datepart(MONTH,transaction_date)=5
)
select  CAST((mtdtotalsales-ptmdtotalsales)AS DECIMAL(10,0))as mom_difference,CAST((mtdtotalsales-ptmdtotalsales)/(ptmdtotalsales)*100 AS decimal(10,0)) as MOMTOTALSALES
from cte

--Total order
select count(transaction_id) as totalorder
from  coffee
WHERE MONTH(TRANSACTION_DATE)=5

----MOM TOTAL ORDER KPI
WITH CTE AS (
SELECT CAST(COUNT(TRANSACTION_ID) AS INT) AS MTDTOTALORDER,(SELECT CAST(COUNT(TRANSACTION_ID) AS INT) FROM COFFEE WHERE MONTH(TRANSACTION_DATE)=4) AS PMTDTOTALORDER
FROM coffee
WHERE MONTH(TRANSACTION_DATE)=5
)

SELECT (MTDTOTALORDER-PMTDTOTALORDER) AS MOMDIFFERENCE,(MTDTOTALORDER-PMTDTOTALORDER)/(PMTDTOTALORDER)*100 AS MOMTOTALORDER
FROM CTE

---TOTAL QUANTITY SOLD
SELECT SUM(TRANSACTION_QTY) AS  TOTALQUATITYSOLD
FROM COFFEE

----MOM TOTAL QUANTITY SOLD
WITH CTE AS(
SELECT SUM(TRANSACTION_QTY) AS MTDQUANTITYSOLD,(SELECT SUM(TRANSACTION_QTY) FROM COFFEE WHERE MONTH(TRANSACTION_DATE)=4) AS PMTDQUANTITYSOLD
FROM COFFEE
WHERE MONTH(TRANSACTION_DATE)=5
)


SELECT (MTDQUANTITYSOLD-PMTDQUANTITYSOLD) AS MOMDIFFERENCCE,Cast((MTDQUANTITYSOLD-PMTDQUANTITYSOLD)/(PMTDQUANTITYSOLD) as decimal(10,2))*100 AS MOM_QUANTITY_SOLD_GROWTH
FROM CTE

--DAILY SALES,QUANTITY AND ORDER
SELECT DATENAME(weekday,transaction_date) as day,cast(sum(unit_price*transaction_qty) as decimal(10,2)) as totalsales
from coffee
group by  DATENAME(weekday,transaction_date)

SELECT DATENAME(weekday,transaction_date) as day,sum(transaction_qty) as totalquantity
from coffee
group by  DATENAME(weekday,transaction_date)

SELECT DATENAME(weekday,transaction_date) as day,count(transaction_id) as totalorder
from coffee
group by  DATENAME(weekday,transaction_date)
---sales trend over a period
select datename(month,transaction_date) as month,cast(sum(unit_price*transaction_qty) as decimal(10,2))
from coffee
group by datename(month,transaction_date)

--avg daily sales
select avg(totalsales) as avgsales
from(
select day(transaction_date) as day,cast(sum(unit_price*transaction_qty) as decimal(10,2)) as totalsales
from coffee
where month(transaction_date)=5
group by day(transaction_date)
) m


-----daily sales vs avg daily sales
with cte as 
(select day(transaction_date) as day,cast(sum(unit_price*transaction_qty) as decimal(10,2)) as totalsales
from coffee
where month(transaction_date)=5
group by day(transaction_date)
),
ctee as (
select *, avg(totalsales) over () as avgsales
from cte
)
select *,
case
when totalsales>avgsales then 'aboveaverage'
when totalsales<avgsales then 'belowaverage'
end  as status
from ctee
order by day asc

---sales by weekend
select sum(totalsales) as weekendsales
from(
select datename(WEEKDAY,transaction_date) AS DAY,cast(sum(unit_price*transaction_qty) as decimal(10,2)) as totalsales
from coffee
where DATENAME(WEEKDAY,transaction_date) in ('saturday','sunday') and month(transaction_date)=5
GROUP BY datename(WEEKDAY,transaction_date) 
)m
--SALES BY WEEKday
select sum(totalsales) as weekdaysales
from(
select datename(WEEKDAY,transaction_date) AS DAY,cast(sum(unit_price*transaction_qty) as decimal(10,2)) as totalsales
from coffee
where DATENAME(WEEKDAY,transaction_date) in ('monday','tuesday','wednessday','thursday','friday','saturday') and month(transaction_date)=5
GROUP BY datename(WEEKDAY,transaction_date) 
)m

----SALES BY STORE LOCATION
SELECT STORE_LOCATION,cast(sum(unit_price*transaction_qty) as decimal(10,2)) as totalsales
FROM coffee
WHERE MONTH(TRANSACTION_DATE)=5
GROUP BY STORE_LOCATION

------SALES BY PRODUCT CATEGORY
select PRODUCT_CATEGORY,cast(sum(unit_price*transaction_qty) as decimal(10,2)) as totalsales
FROM COFFEE
WHERE MONTH(TRANSACTION_DATE)=5
GROUP BY PRODUCT_CATEGORY

------SALES BY PRODUCT
SELECT TOP 10 PRODUCT_TYPE,cast(sum(unit_price*transaction_qty) as decimal(10,2)) as totalsales
FROM COFFEE
WHERE MONTH(TRANSACTION_DATE)=5
GROUP BY product_type
ORDER BY totalsales DESC

---SALES BY DAY
SELECT DATENAME(WEEKDAY,TRANSACTION_DATE) AS DAY,cast(sum(unit_price*transaction_qty) as decimal(10,2)) as totalsales
FROM coffee
WHERE MONTH(TRANSACTION_DATE)=5
GROUP BY DATENAME(WEEKDAY,TRANSACTION_DATE)


---SALES BY HOUR
SELECT DATEPART(HOUR,TRANSACTION_TIME) AS HOUR,cast(sum(unit_price*transaction_qty) as decimal(10,2)) as totalsales
FROM COFFEE
WHERE MONTH(TRANSACTION_DATE)=5
GROUP BY DATEPART(HOUR,TRANSACTION_TIME) 
ORDER BY  HOUR ASC













--if daily sales greater than ,then above average,if daily sales less than,then below average
select PRODUCT_CATEGORY,













ALTER TABLE COFFEE
ALTER COLUMN TRANSACTION_ID INT































select product_id,transaction_date,store_location,sum(unit_price) over (partition by store_location,transaction_date) as rolloverprice
from coffee














