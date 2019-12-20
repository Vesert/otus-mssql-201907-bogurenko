USE WideWorldImporters;

--1. ѕосчитать среднюю цену товара, общую сумму продажи по мес€цам
SELECT
          il.Description
        , MONTH (i.InvoiceDate) AS [month]
        , AVG (unitprice)       AS avg_price
        , SUM (quantity)        AS total_sales_qty
FROM
          [Sales].[InvoiceLines] il
          JOIN
                    [Sales].[Invoices] i
          ON
                    il.invoiceid = i.InvoiceID
GROUP BY
          il.Description
        , MONTH (i.InvoiceDate)
ORDER BY
          il.Description
        , [month]


-- 2. ќтобразить все мес€цы, где обща€ сумма продаж превысила 10 000 
SELECT
          dateadd(day,-day(i.invoicedate)+1,i.InvoiceDate) year_month
        , SUM (quantity)        AS summa
FROM
          [Sales].[InvoiceLines] il
          JOIN
                    [Sales].[Invoices] i
          ON
                    il.InvoiceId = i.InvoiceId
GROUP BY
          dateadd(day,-day(i.invoicedate)+1,i.InvoiceDate)
HAVING
          SUM (quantity * UnitPrice) > 10000
ORDER BY
          year_month;


--3. ¬ывести сумму продаж, дату первой продажи и количество проданного по мес€цам, по товарам, продажи которых менее 50 ед в мес€ц.
SELECT
          dateadd(day,-day(i.invoicedate)+1,i.InvoiceDate) year_month
        , SUM (quantity)        AS total_sale_qty
        , MIN (i.invoiceDate)   AS min_date
        , s.stockitemname
        , COUNT(quantity) AS qty_sale
FROM
          [Sales].[InvoiceLines] il
          JOIN
                    [Sales].[Invoices] i
          ON
                    il.InvoiceId = i.InvoiceId
          JOIN
                    [Warehouse].[StockItems] s
          ON
                    il.StockItemID = s.StockItemID
GROUP BY
          dateadd(day,-day(i.invoicedate)+1,i.InvoiceDate)
        , s.stockitemname
HAVING
          SUM(quantity) < 50
ORDER BY
	      year_month
;

--4. Ќаписать рекурсивный CTE sql запрос и заполнить им временную таблицу и табличную переменную
WITH directReports (EmployeeID,FirstName,LastName,Title,ManagerID, employeelevel) AS
(
          SELECT
                    EmployeeID
                  , FirstName
                  , LastName
                  , Title
                  , ManagerID
                  , 1 AS employeelevel
          FROM
                    dbo.MyEmployees
          WHERE
                    managerid IS NULL
          
          UNION ALL
          
          SELECT
                    q.EmployeeID
                  , q.FirstName
                  , q.LastName
                  , q.Title
                  , q.ManagerID
                  , employeelevel + 1
          FROM
                    dbo.MyEmployees q
                    JOIN
                              directReports d
                    ON
                              q.managerid = d.employeeid
)
SELECT
          employeeid
        , concat (FirstName, ' ' ,LastName) AS name
        , Title
        , employeelevel
FROM
          directReports
ORDER BY
          employeeid
        , name
        , Title
        , employeelevel;