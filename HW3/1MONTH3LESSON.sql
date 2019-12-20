USE WideWorldImporters;

--1.�������� �����������, ������� �������� ������������, � ��� �� ������� �� ����� �������
--��������� ���������
SELECT
          p.PersonID
        , p.FullName
FROM
          Application.People p
WHERE
          p.IsSalesperson = 1
          AND NOT EXISTS
          (
                    SELECT
                              1
                    FROM
                              Sales.Invoices i
                    WHERE
                              i.SalespersonPersonID = p.PersonID
          );

--����������� ���������
--����� ��� ���������� ����
SELECT
          p.PersonID
        , p.FullName
FROM
          Application.People p
WHERE
          p.IsSalesperson = 1
          AND PersonID NOT IN
          ( 
		  SELECT SalespersonPersonID FROM sales.invoices
          );

-- ����� with
WITH salers AS
          (
                    SELECT
                              PersonID
                            , FullName
                    FROM
                              Application.People p
                    WHERE
                              p.IsSalesperson = 1
          )
SELECT
          PersonID
        , FullName
FROM salers
where PersonID not in (select salespersonpersonid from sales.invoices)

--2.�������� ������ � ����������� ����� 
SELECT  *
FROM
          Warehouse.StockItems
WHERE
          UnitPrice =
          ( SELECT MIN(UnitPrice) FROM Warehouse.StockItems
          )
;

SELECT  *
FROM
          Warehouse.StockItems
WHERE
          UnitPrice <= ALL
          ( SELECT UnitPrice FROM Warehouse.StockItems
          )
;

WITH min_price AS
          ( SELECT MIN(UnitPrice) min_price FROM Warehouse.StockItems
          )
SELECT  *
FROM
          Warehouse.StockItems
WHERE
          UnitPrice =
          ( SELECT      * FROM min_price
          )
;

--3.�������� ���������� �� ��������, ������� �������� �������� 5 ������������ �������� �� [Sales].[CustomerTransactions]
SELECT  c.*
FROM
          Sales.CustomerTransactions ct
INNER JOIN
          Sales.Customers c
ON
          ct.CustomerID = c.CustomerID
WHERE
          CustomerTransactionID IN
          (
                    SELECT      TOP 5 CUSTOMERTRANSACTIONID
                    FROM
                              Sales.CustomerTransactions
                    ORDER BY
                              TransactionAmount DESC
          )
;

SELECT  c.*
FROM
          Sales.CustomerTransactions ct
INNER JOIN
          Sales.Customers c
ON
          ct.CustomerID = c.CustomerID
WHERE
          TransactionAmount >= ANY
          (
                    SELECT      TOP 5 TRANSACTIONAMOUNT
                    FROM
                              Sales.CustomerTransactions
                    ORDER BY
                              TransactionAmount DESC
          )
;

WITH five_max_customer_transaction AS
          (
                    SELECT    TOP 5 CUSTOMERTRANSACTIONID
                    FROM
                              Sales.CustomerTransactions
                    ORDER BY
                              TransactionAmount DESC
          )
SELECT  c.*
FROM
          sales.CustomerTransactions ct
INNER JOIN
          Sales.Customers c
ON
          ct.CustomerID = c.CustomerID
WHERE
          CustomerTransactionID IN
          ( SELECT      * FROM five_max_customer_transaction
          )
;

--4 �������� ������ (�� � ��������), � ������� ���� ���������� ������, �������� � ������ ����� ������� �������, � ����� ��� ����������, ������� ����������� �������� �������
SELECT  DISTINCT
          city.CityID
        , city.CityName
        , p.FullName
FROM
          Sales.Invoices i
          INNER JOIN
                    (
                              SELECT
                                        InvoiceID
                              FROM
                                        sales.InvoiceLines
                              WHERE
                                        UnitPrice IN
                                        (
                                                  SELECT          DISTINCT
                                                            top 3 UnitPrice
                                                  FROM
                                                            Sales.InvoiceLines
                                                  ORDER BY
                                                            UnitPrice DESC
                                        )
                    )
                    top_three_stock
          ON
                    top_three_stock.InvoiceID = i.InvoiceID
          INNER JOIN
                    Sales.Customers c
          ON
                    i.CustomerID = c.CustomerID
          INNER JOIN
                    Application.Cities city
          ON
                    c.DeliveryCityID = city.CityID
          INNER JOIN
                    Application.People p
          ON
                    i.PackedByPersonID = p.PersonID
;

WITH three_max_stock AS
          (
                    SELECT
                              InvoiceID
                    FROM
                              sales.InvoiceLines
                    WHERE
                              UnitPrice IN
                              (
                                        SELECT        DISTINCT
                                                  top 3 UnitPrice
                                        FROM
                                                  Sales.InvoiceLines
                                        ORDER BY
                                                  UnitPrice DESC
                              )
          )
SELECT  DISTINCT
          city.CityID
        , city.CityName
        , p.FullName
FROM
          Sales.Invoices i
          INNER JOIN
                    three_max_stock
          ON
                    three_max_stock.InvoiceID = i.InvoiceID
          INNER JOIN
                    Sales.Customers c
          ON
                    i.CustomerID = c.CustomerID
          INNER JOIN
                    Application.Cities city
          ON
                    c.DeliveryCityID = city.CityID
          INNER JOIN
                    Application.People p
          ON
                    i.PackedByPersonID = p.PersonID
;