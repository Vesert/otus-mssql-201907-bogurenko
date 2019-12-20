USE [WideWorldImporters];


--1 insert записей
INSERT INTO [Sales].[Customers]
          (
                    [CustomerID]
                  , [CustomerName]
                  , [BillToCustomerID]
                  , [CustomerCategoryID]
                  , [BuyingGroupID]
                  , [PrimaryContactPersonID]
                  , [AlternateContactPersonID]
                  , [DeliveryMethodID]
                  , [DeliveryCityID]
                  , [PostalCityID]
                  , [CreditLimit]
                  , [AccountOpenedDate]
                  , [StandardDiscountPercentage]
                  , [IsStatementSent]
                  , [IsOnCreditHold]
                  , [PaymentDays]
                  , [PhoneNumber]
                  , [FaxNumber]
                  , [DeliveryRun]
                  , [RunPosition]
                  , [WebsiteURL]
                  , [DeliveryAddressLine1]
                  , [DeliveryAddressLine2]
                  , [DeliveryPostalCode]
                  , [DeliveryLocation]
                  , [PostalAddressLine1]
                  , [PostalAddressLine2]
                  , [PostalPostalCode]
                  , [LastEditedBy]
          )
          VALUES
          (
                    1225
                  ,'Tailspin Toys (Office № 1)' , 1 , 3 , 1 , 1001 , 1002 , 3 , 19586 , 19586
                  , NULL
                  ,'2013-01-01'
                  , 0.000 , 0 , 0 , 7
                  ,'(308) 555-0100'
                  ,'(308) 555-0101'
                  , NULL
                  , NULL
                  ,'http://www.tailspintoys.com'
                  ,'1877 Mittal Road'
                  ,'1877 Mittal Road' , 90410
                  , 0xE6100000010CE73F5A52A4BF444010638852B1A759C0
                  ,'PO Box 8975'
                  ,'Ribeiroville' , 90410 , 1
          )
        ,
           (
                    1226
                  ,'Tailspin Toys (Office № 2)' , 1 , 3 , 1 , 1001 , 1002 , 3 , 19586 , 19586
                  , NULL
                  ,'2013-01-01'
                  , 0.000 , 0 , 0 , 7
                  ,'(308) 555-0100'
                  ,'(308) 555-0101'
                  , NULL
                  , NULL
                  ,'http://www.tailspintoys.com'
                  ,'1877 Mittal Road'
                  ,'1877 Mittal Road' , 90410
                  , 0xE6100000010CE73F5A52A4BF444010638852B1A759C0
                  ,'PO Box 8975'
                  ,'Ribeiroville' , 90410 , 1
          )
        ,
           (
                    1227
                  ,'Tailspin Toys (Office № 3)' , 1 , 3 , 1 , 1001 , 1002 , 3 , 19586 , 19586
                  , NULL
                  ,'2013-01-01'
                  , 0.000 , 0 , 0 , 7
                  ,'(308) 555-0100'
                  ,'(308) 555-0101'
                  , NULL
                  , NULL
                  ,'http://www.tailspintoys.com'
                  ,'1877 Mittal Road'
                  ,'1877 Mittal Road' , 90410
                  , 0xE6100000010CE73F5A52A4BF444010638852B1A759C0
                  ,'PO Box 8975'
                  ,'Ribeiroville' , 90410 , 1
          )
        ,
           (
                    1228
                  ,'Tailspin Toys (Office № 4)' , 1 , 3 , 1 , 1001 , 1002 , 3 , 19586 , 19586
                  , NULL
                  ,'2013-01-01'
                  , 0.000 , 0 , 0 , 7
                  ,'(308) 555-0100'
                  ,'(308) 555-0101'
                  , NULL
                  , NULL
                  ,'http://www.tailspintoys.com'
                  ,'1877 Mittal Road'
                  ,'1877 Mittal Road' , 90410
                  , 0xE6100000010CE73F5A52A4BF444010638852B1A759C0
                  ,'PO Box 8975'
                  ,'Ribeiroville' , 90410 , 1
          )
        ,
           (
                    1229
                  ,'Tailspin Toys (Office № 5)' , 1 , 3 , 1 , 1001 , 1002 , 3 , 19586 , 19586
                  , NULL
                  ,'2013-01-01'
                  , 0.000 , 0 , 0 , 7
                  ,'(308) 555-0100'
                  ,'(308) 555-0101'
                  , NULL
                  , NULL
                  ,'http://www.tailspintoys.com'
                  ,'1877 Mittal Road'
                  ,'1877 Mittal Road' , 90410
                  , 0xE6100000010CE73F5A52A4BF444010638852B1A759C0
                  ,'PO Box 8975'
                  ,'Ribeiroville' , 90410 , 1
          )
;



--2 Удаление клиента с id 1225
DELETE FROM Sales.Customers WHERE CustomerID = 1225;



--3 обновление имени клиента с id 1226
UPDATE
          Sales.Customers
SET       CustomerName = 'Tailspin Toys (MAIN Office)'
WHERE
          CustomerID = 1226
;


--4 MERGE с OUTPUT
--  OUTPUT используется для отображения где произошел UPDATE, а где INSERT

select top 0 * into #extraCities from Application.Cities

INSERT INTO #extraCities
           ([CityID]
           ,[CityName]
           ,[StateProvinceID]
           ,[Location]
           ,[LatestRecordedPopulation]
           ,[LastEditedBy]
		   ,[ValidFrom]
		   ,[ValidTo])
     VALUES
           (1,'Aaronsburg',39,0xE6100000010C07E11B542C73444087C09140035D53C0,620,1,'2013-01-01 00:00:00.0000000',	'9999-12-31 23:59:59.9999999'),
		   (3,'Abanda',1,0xE6100000010C4033880FEC8C4040EFBF3A33E66155C0,112,1,'2013-01-01 00:00:00.0000000',	'9999-12-31 23:59:59.9999999'),
		   (4,'Abbeville',42,0xE6100000010C79C83956CE164140CCAC4AC7419854C0,10237,1,'2013-01-01 00:00:00.0000000',	'9999-12-31 23:59:59.9999999'),
		   (1112031,'ImagineMoscow',42,0xE6100000010C79C83956CE164140CCAC4AC7419854C0,1250000,1,'2013-01-01 00:00:00.0000000',	'9999-12-31 23:59:59.9999999'),
		   (1112032,'ImagineMoscow2',42,0xE6100000010C79C83956CE164140CCAC4AC7419854C0,1250000,1,'2013-01-01 00:00:00.0000000',	'9999-12-31 23:59:59.9999999');


MERGE Application.Cities base_city
USING #extraCities source_city
on (base_city.CityID =source_city.CityID)
WHEN MATCHED THEN
	UPDATE SET LatestRecordedPopulation = source_city.LatestRecordedPopulation
WHEN NOT MATCHED THEN
	INSERT ([CityID],[CityName],[StateProvinceID],[Location],[LatestRecordedPopulation],[LastEditedBy])
	VALUES (source_city.CityID,source_city.CityName,source_city.StateProvinceID,source_city.[Location],source_city.[LatestRecordedPopulation],source_city.LastEditedBy)
OUTPUT $action AS [Операция], Inserted.CityId,
                   Inserted.LatestRecordedPopulation AS newLatestRecordedPopulation,
                   Inserted.CityName newCityName,
                   Deleted.LatestRecordedPopulation AS newLatestRecordedPopulation,
                   Deleted.CityName oldCityName;


--5 bcp и bulk insert
-- Такой странный путь до файла для выгрузки в bcp объяняется отсуствием прав
EXEC sp_configure
          'show advanced options'
          , 1;


GO
-- To update the currently configured value for advanced options.
RECONFIGURE;


GO
-- To enable the feature.
EXEC sp_configure
          'xp_cmdshell'
          , 1;


GO
-- To update the currently configured value for this feature.
RECONFIGURE;


GO
EXEC master..xp_cmdshell 'bcp "[WideWorldImporters].Sales.Orders" out  "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\test_bcp.txt" -w  -t";", -S localhost -T -b 10000'
SELECT TOP 0 * INTO sales.CopyOrders FROM Sales.Orders
SELECT * FROM sales.CopyOrders BULK
INSERT [WideWorldImporters].Sales.CopyOrders
FROM
          "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\test_bcp.txt" WITH
          (
                    BATCHSIZE       = 1
                  , DATAFILETYPE    = 'widechar'
                  , FIELDTERMINATOR = ';'
                  , ROWTERMINATOR   ='\n'
                  , KEEPNULLS
                  , TABLOCK
          )
;

