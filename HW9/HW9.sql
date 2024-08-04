-- ---------------------------------------------------------------------------
-- ������� - �������� ������� ��� ��������� ��������� ���� ������.
-- ---------------------------------------------------------------------------


USE WideWorldImporters

/*
1. ����������� � ���� ���� ������� ��������� insert � ������� Customers ��� Suppliers 
*/

-- �������� 2 ������, ����� ����� ���������
drop table if exists #tmp
create table #tmp (id int)

insert into Purchasing.Suppliers (
    [SupplierName] ,
	[SupplierCategoryID],
	[PrimaryContactPersonID],
	[AlternateContactPersonID],
	[DeliveryMethodID],
	[DeliveryCityID],
	[PostalCityID],
	[SupplierReference],
	[BankAccountName],
	[BankAccountBranch],
	[BankAccountCode],
	[BankAccountNumber],
	[BankInternationalCode],
	[PaymentDays],
	[InternalComments],
	[PhoneNumber],
	[FaxNumber],
	[WebsiteURL],
	[DeliveryAddressLine1],
	[DeliveryAddressLine2],
	[DeliveryPostalCode],
	[DeliveryLocation],
	[PostalAddressLine1],
	[PostalAddressLine2],
	[PostalPostalCode],
	[LastEditedBy]
	)
	output inserted.SupplierID into #tmp (id)
	VALUES
	('New2_Corporation',
	2,	
	21,	
	22,	
	7,	
	38171,--
	38171,--
	'AA20384',	
	'A Corporation',
	'Woodgrove Bank Zionsville',
	356981,
	8575824136,
	25986,
	14,
	NULL,	
	'(847) 555-0100',	
	'(847) 555-0101',	
	'http://www.adatum.com',
	'Suite 10',	
	'183838 Southwest Boulevard',
	 46077,	
	geography::STGeomFromText('LINESTRING(-122.360 47.656, -122.343 47.656 )',4326)	,
	'PO Box 1039',	
	'Surrey',
	46077,
	1)�
	('New_Corporation',
	2,	
	21,	
	22,	
	7,	
	38171,--
	38171,--
	'AA20384',	
	'A Corporation',
	'Woodgrove Bank Zionsville',
	356981,
	8575824136,
	25986,
	14,
	NULL,	
	'(847) 555-0100',	
	'(847) 555-0101',	
	'http://www.adatum.com',
	'Suite 10',	
	'183838 Southwest Boulevard',
	 46077,	
	geography::STGeomFromText('LINESTRING(-122.360 47.656, -122.343 47.656 )',4326)	,
	'PO Box 1039',	
	'Surrey',
	46077,
	1)
	
	select * from #tmp

							 ,
/*
2. ������� ���� ������ �� Customers, ������� ���� ���� ���������
*/

delete from  Purchasing.Suppliers
where SupplierID = 16


/*
3. �������� ���� ������, �� ����������� ����� UPDATE
*/

update Purchasing.Suppliers
set SupplierName = 'Name_New_Corporation'
where SupplierID = 17

/*
4. �������� MERGE, ������� ������� ������� ������ � �������, ���� �� ��� ���, � ������� ���� ��� ��� ����
*/

-- ����������� ���� ������� #Clients � ������ ����� ����������� �������� � �� ��������� �����

-- merge �� ����� ��������, ��� ��� � ������� �� ��� ������������ ���� �������������. ���� ��������, ������� � ����� ���� ������, ��� ��� � ����� ������ ����� ���������
 MERGE Sales.Customers AS sc
    USING (SELECT Name, Limit from #Clients) AS src(Name, Limit)
        ON (sc.CustomerName = src.Name)
    WHEN MATCHED
        THEN
            UPDATE
            SET CreditLimit = src.Limit
    WHEN NOT MATCHED
        THEN
            INSERT (CustomerName, Limit)
            VALUES (src.UName, src.Limit)

/*
5. �������� ������, ������� �������� ������ ����� bcp out � ��������� ����� bulk insert
*/

�������� ����� ���� �������
 
EXEC sp_configure 'show advanced options', 1;  
GO  
-- To update the currently configured value for advanced options.  
RECONFIGURE;  
GO  
-- To enable the feature.  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
GO  

--SELECT @@SERVERNAME;

DECLARE @out varchar(250);
set @out = 'bcp WideWorldImporters.Sales.Customers OUT "E:\BCP\Customers.txt" -T -S ' + @@SERVERNAME + ' -c';
PRINT @out;

EXEC master..xp_cmdshell @out

DROP TABLE IF EXISTS WideWorldImporters.Sales.Customers_Copy;
SELECT * INTO WideWorldImporters.Sales.Customers_Copy FROM WideWorldImporters.Sales.Customers
WHERE 1 = 2; 


DECLARE @in varchar(250);
set @in = 'bcp WideWorldImporters.Sales.Customers_Copy IN "E:\BCP\Customers.txt" -T -S ' + @@SERVERNAME + ' -c';

EXEC master..xp_cmdshell @in;

SELECT *
FROM WideWorldImporters.Sales.Customers_Copy;
