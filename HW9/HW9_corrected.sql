-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------


USE WideWorldImporters

/*
1. Довставлять в базу пять записей используя insert в таблицу Customers или Suppliers 
*/

-- вставила 2 записи, иначе очень громоздко
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
	1),
	('New_Corporation3',
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

							 

/*
4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть
*/

 MERGE Sales.Customers AS sc
    USING (SELECT Name from #Clients) AS src(Name)
        ON (sc.CustomerName = src.Name)
    WHEN MATCHED
        THEN
            UPDATE
            SET BillToCustomerID = src.BillToCustomerID,
			CustomerCategoryid = src.CustomerCategoryID,
			BuyingGroupID  src.BuingGroupID,
			PrimaryContactPersonID = src.PrimaryContactPersonID,
			AlternateContactPersonID = src.AlternateContactPersonID,
			DeliveryMethodID = src.DeliveryMethodID,
			DeliveryCityID = src.DeliveryCityID,
			PostalCityID = src.PostalCityID,
			CreditLimit = src.CreditLimit,
			AccontOpenedDate = src.AccountOpenedDate,
			StandartDiscountPercentage = src.StandartDiscountPercentage,
			IsStatemantSent = src.IsStatemantSent,
			IsOnCreditHold = src.IsOnCreditHold,
			PaymentDays  src.PaymentDays,
			PhonaNumber = src.PhoneNumber,
			FaxNumber = src.FaxNumber,
			DeliveryRun = src.DeliveryRun,
			RunPosition = src.RunPosition,
			WebsiteURL = src.WebsiteURL,
			DeliveryAddressLine1 = src.DeliveryAddressLine1,
			DeliveryAddressLine2 = src.DeliveryAddressLine2,
			DeliveryPostalCode = src.DeliveryPostalCode,
			DeliveryLocation = src.DeliveryLocation,
			PostalAddressLine1 = src.PostalAddressLine1,
			PostalAddressLine2 = src.PostalAddressLine2,
			PostalPostalCode = src.PostalPostalCode,
			LastEditedBy = src.LastEditedBy,  --getdate()?
			ValidFrom = src.ValidFrom,
			ValidTo = src.ValidTo
			CreditLimit = src.Limit
    WHEN NOT MATCHED
        THEN
            INSERT 
            VALUES (src.CustomerName, src.BillToCustomerID,
			src.CustomerCategoryID,
			src.BuingGroupID,
			src.PrimaryContactPersonID,
			src.AlternateContactPersonID,
			src.DeliveryMethodID,
			src.DeliveryCityID,
			src.PostalCityID,
			src.CreditLimit,
			src.AccountOpenedDate,
			src.StandartDiscountPercentage,
			src.IsStatemantSent,
			src.IsOnCreditHold,
			src.PaymentDays,
			src.PhoneNumber,
			src.FaxNumber,
			src.DeliveryRun,
			src.RunPosition,
			src.WebsiteURL,
			src.DeliveryAddressLine1,
			src.DeliveryAddressLine2,
			src.DeliveryPostalCode,
			src.DeliveryLocation,
			src.PostalAddressLine1,
			src.PostalAddressLine2,
			src.PostalPostalCode,
			src.LastEditedBy,  --getdate()?
			src.ValidFrom,
			src.ValidTo
			src.Limit
 )

