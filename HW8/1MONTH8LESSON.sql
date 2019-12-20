--1
select * from (
select InvoiceID,
       format(DATEADD(day,-(day(invoiceDate)-1),InvoiceDate),'dd.MM.yyyy') month_sale,
	   substring(CustomerName,CHARINDEX('(',CustomerName)+1,len(CustomerName)-CHARINDEX('(',CustomerName) -1) name_cust 
from sales.invoices i
inner join sales.Customers c
on i.CustomerID = c.CustomerID
where c.CustomerID in (2,3,4,5,6)
) as toys_invoices
pivot
(
count(invoiceid)
for [name_cust] in ([Gasport, NY],
                  [Jessie, ND],
				  [Medicine Lodge, KS],
				  [Peeples Valley, AZ],
				  [Sylvanite, MT])
) as pvt

--2
select customername+ ' '+addresline from (
select CustomerName,DeliveryAddressLine1,DeliveryAddressLine2 from Sales.Customers
where CustomerName like 'Tailspin Toys%'
) as customerAddress
unpivot (addresline for column_name in (DeliveryAddressLine1,DeliveryAddressLine2)) as pvt

--3
select CountryID,countryname,code from (
select countryid,CountryName,IsoAlpha3Code,cast(IsoNumericCode as nvarchar(3)) IsoNumericCode  from Application.Countries) as country_codes
unpivot (code for column_name in (IsoAlpha3Code,IsoNumericCode)) as unpvt


--4
select c.CustomerID,
       c.CustomerName,
	   top_two_sale.InvoiceDate,
	   top_two_sale.StockItemID,
	   top_two_sale.UnitPrice 
from sales.Customers c
cross apply (select top 2 i.InvoiceDate, UnitPrice ,il.StockItemID
             from sales.Invoices i 
             inner join sales.InvoiceLines il
			 on i.InvoiceID = il.InvoiceID
			 where i.CustomerID = c.CustomerID
			 order by il.UnitPrice desc) top_two_sale
