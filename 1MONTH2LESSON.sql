USE wideworldimporters;

--1. ��� ������, � ������� � �������� ���� ������� urgent ��� �������� ���������� � Animal
SELECT * 
FROM   [Warehouse].[stockitems] 
WHERE  stockitemname LIKE '%urgent%' 
OR     stockitemname LIKE 'Animal%';

--2. �����������, � ������� �� ���� ������� �� ������ ������ 
SELECT DISTINCT s.supplierid, 
                s.suppliername 
FROM            [Purchasing].[suppliers] s 
LEFT JOIN       [Purchasing].[purchaseorders] po 
ON              s.supplierid = po.supplierid 
WHERE           po.purchaseorderid IS NULL;

DECLARE @pagesize BIGINT = 100, 
  @pagenum        BIGINT = 11;


--3.������� � ��������� ������, � ������� ���� �������, ������� ��������, � �������� ��������� �������, �������� ����� � ����� ����� ���� ��������� ���� - ������ ����� �� 4 ������, ���� ������ ������ ������ ���� ������, � ����� ������ ����� 100$ ���� ���������� ������ ������ ����� 20
SELECT     i.invoicedate, 
           Datename(month,i.invoicedate)                  month_name, 
           Ceiling(Cast(Month(i.invoicedate) AS FLOAT)/4) term_year, 
           Ceiling(Cast(Month(i.invoicedate) AS FLOAT)/3) quarter_year, 
           il.quantity, 
           il.unitprice, 
           il.[Description] 
FROM       sales.invoices i 
INNER JOIN sales.invoicelines il 
ON         i.invoiceid = il.invoiceid 
WHERE      il.unitprice > 100 
OR         il.quantity > 20 
ORDER BY   quarter_year, 
           term_year, 
           i.invoicedate offset (@pagenum - 1) * @pagesize rowsFETCH next @pagesize rows only;

--4.������ �����������, ������� ���� ��������� �� 2014� ��� � ��������� Road Freight ��� Post, �������� �������� ����������, ��� ����������� ���� ������������ �����
SELECT     po.purchaseorderid, 
           po.orderdate, 
           s.suppliername, 
           dm.deliverymethodname, 
           p.fullname 
FROM       [Purchasing].[purchaseorders] po 
INNER JOIN [Application].[deliverymethods] dm 
ON         po.deliverymethodid = dm.deliverymethodid 
INNER JOIN purchasing.suppliers s 
ON         po.supplierid = s.supplierid 
INNER JOIN application.people p 
ON         po.contactpersonid = p.personid 
WHERE      po.orderdate >= '2014-01-01' 
AND        po.orderdate < '2015-01-01' 
AND        dm.deliverymethodname IN ('Road Freight', 
                                     'Post') 
ORDER BY   po.orderdate;

--5. 10 ��������� �� ���� ������ � ������ ������� � ������ ����������, ������� ������� �����.
SELECT  TOP 10   i.invoiceid, 
           p1.fullname salesPersonFullname, 
           p2.fullname customerPersonFullname
FROM       sales.invoices i 
INNER JOIN application.people p1 
ON         i.salespersonpersonid = p1.personid 
INNER JOIN application.people p2 
ON         i.customerid = p2.personid 
ORDER BY   i.invoicedate DESC;


--6. ��� �� � ����� �������� � �� ���������� ��������, ������� �������� ����� Chocolate frogs 250g 
SELECT     p.personid, 
           p.fullname, 
           p.phonenumber, 
           il.[description] 
FROM       sales.invoices i 
INNER JOIN [Sales].[invoicelines] il 
ON         i.invoiceid = il.invoiceid 
INNER JOIN application.people p 
ON         i.customerid = p.personid 
WHERE      il.[description] = 'Chocolate frogs 250g';



 