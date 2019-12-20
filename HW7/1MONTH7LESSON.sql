use WideWorldImporters;

SET STATISTICS TIME ON
 
select DATEADD(day,-day(i.invoiceDate) +1,i.invoiceDate) month_year,sum(il.Quantity*il.UnitPrice) sum_itog into #temptabletest from sales.invoices i
inner join sales.InvoiceLines il
on i.InvoiceID = il.InvoiceID
WHERE i.InvoiceDate >= '2015-01-01' AND i.InvoiceDate <= '2015-12-31'
group by DATEADD(day,-day(i.invoiceDate) +1,i.invoiceDate)

select distinct
inv.InvoiceID,
cust.CustomerName,
inv.InvoiceDate,
(select sum(il.Quantity * il.UnitPrice) from sales.InvoiceLines il where il.InvoiceID = inv.invoiceid) total_sum,
itog.narast_itog
FROM Sales.Invoices inv
join Sales.Customers cust on inv.CustomerID = cust.CustomerID
join Sales.InvoiceLines il on il.InvoiceID = inv.InvoiceID
join (
select month_year, 
      (select SUM(sum_itog) from #temptabletest t2 where t2.month_year <=t1.month_year) narast_itog 
from #temptabletest t1
) itog
on itog.month_year= DATEADD(day,-day(inv.invoiceDate) +1,inv.invoiceDate) 
order by inv.invoiceDate;


select distinct
inv.InvoiceID,
cust.CustomerName,
inv.InvoiceDate,
SUM(il.Quantity * il.UnitPrice) OVER (PARTITION BY inv.InvoiceID) as sum_prod, 
SUM(il.Quantity * il.UnitPrice) OVER (ORDER BY DATEADD(day,-day(inv.invoiceDate) +1,inv.invoiceDate)) as sum_itog
FROM Sales.Invoices inv
join Sales.Customers cust on inv.CustomerID = cust.CustomerID
join Sales.InvoiceLines il on il.InvoiceID = inv.InvoiceID
WHERE inv.InvoiceDate >= '2015-01-01' AND inv.InvoiceDate <= '2015-12-31'
order by inv.invoiceDate;


/*ОКОННАЯ ФУНКЦИЯ ОТРАБАТЫВАЕТ БЫСТРЕЕ
 Время работы SQL Server:
   Время ЦП = 250 мс, затраченное время = 5169 мс.

(затронуто строк: 12)
Время синтаксического анализа и компиляции SQL Server: 
 время ЦП = 94 мс, истекшее время = 117 мс.

(затронуто строк: 22250)

 Время работы SQL Server:
   Время ЦП = 125 мс, затраченное время = 456 мс.

(затронуто строк: 22250)

 Время работы SQL Server:
   Время ЦП = 172 мс, затраченное время = 543 мс.
*/

--2 
with sales_on_product_month as (
select Month(i.InvoiceDate) month_idate,il.StockItemID,sum(Quantity) sum_qty
 from Sales.Invoices i
inner join Sales.InvoiceLines il
on i.InvoiceID = il.InvoiceID
where InvoiceDate >= '2016-01-01' and InvoiceDate <'2017-01-01'
group by Month(i.InvoiceDate),il.StockItemID)
select ranked_qty_table.month_idate,
       ranked_qty_table.sum_qty,
	   si.StockItemName
 from (
select sales_on_product_month.*, ROW_NUMBER() OVER(PARTITION BY month_idate ORDER BY sum_qty desc) as rank_sum_qty
from sales_on_product_month) ranked_qty_table
inner join Warehouse.StockItems si on
si.StockItemID = ranked_qty_table.StockItemID
where ranked_qty_table.rank_sum_qty <=2


--3
select count(*) from Warehouse.StockItems
group by TypicalWeightPerUnit
select si.StockItemID,
              si.StockItemName,
			  si.UnitPrice,
			  si.Brand,
			  si.typicalweightperunit,
			  ROW_NUMBER() OVER (PARTITION BY LEFT(si.StockItemName,1) ORDER BY StockItemID) as row_num_by_alphabet,
			  COUNT(*) OVER() total_qty,
			  COUNT(*) OVER (PARTITION BY LEFT(si.StockItemName,1)) as sum_qty_by_alphabet,
			  LEAD(StockItemId) OVER (ORDER BY si.StockItemName) next_stockItemId,
			  LAG(StockItemId) OVER (ORDER BY si.StockItemName) prev_stockItemId,
			  LAG(StockItemName,2,'No Items') OVER (ORDER BY si.StockItemName) two_prev_StockName,
			  NTILE(30) over (order by TypicalWeightPerUnit) ntiled_weight_num
from Warehouse.StockItems si
order by ntiled_weight_num

--4
select last_sale.*, il.Quantity*il.UnitPrice last_summ_sale from (
select InvoiceId,SalespersonPersonID,CustomerID,invoicedate,
ROW_NUMBER() over(partition by SalespersonPersonID order by invoicedate desc) num_row_over_salesperson
from sales.Invoices
) last_sale 
inner join sales.InvoiceLines il on
last_sale.InvoiceID =il.InvoiceID
where last_sale.num_row_over_salesperson = 1