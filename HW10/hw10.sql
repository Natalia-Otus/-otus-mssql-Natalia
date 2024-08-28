1.
DECLARE @xmlDocument XML;


SELECT @xmlDocument = BulkColumn
FROM OPENROWSET
(BULK 'C:\Users\пользователь\Documents\StockItems.xml', 
 SINGLE_CLOB)
AS data;

-- Проверяем, что в @xmlDocument
SELECT @xmlDocument AS [@xmlDocument];

DECLARE @docHandle INT;
EXEC sp_xml_preparedocument @docHandle OUTPUT, @xmlDocument;



SELECT @docHandle AS docHandle;

DROP TABLE IF EXISTS #Items;

CREATE TABLE #Items(
[StockItemName] nvarchar(100),
	[SupplierID] INT,
	[UnitPackageID] INT,
	[OuterPackageID] INT,
	[LeadTimeDays] INT,
	[IsChillerStock] BIT,
	[TaxRate] DECIMAL(18,3),
	[UnitPrice] DECIMAL(18,2)
);


INSERT INTO #Items
SELECT *
FROM OPENXML(@docHandle, N'/StockItems/Item')
WITH ( 
	[StockItemName] nvarchar(100)  '@Name',
	[SupplierID] INT 'SupplierID',
	[UnitPackageID] INT 'Package/UnitPackageID',
	[OuterPackageID] INT 'Package/OuterPackageID',
	[LeadTimeDays]INT 'LeadTimeDays',
	[IsChillerStock] BIT 'IsChillerStock',
	[TaxRate] DECIMAL(18,3) 'TaxRate',
	[UnitPrice] DECIMAL(18,2) 'UnitPrice');

	select * from #Items

-- XQuery

	select @xmlDocument.value('(/StockItems/Item/@Name)[1]', 'varchar(100)'), 
	@xmlDocument.value('(/StockItems/Item/SupplierID)[1]', 'INT'),
	@xmlDocument.value('(/StockItems/Item/Package/UnitPackageID)[1]', 'INT'),
	@xmlDocument.value('(/StockItems/Item/Package/OuterPackageID)[1]', 'INT'),
	@xmlDocument.value('(/StockItems/Item/Package/LeadTimeDays)[1]', 'INT'),
	@xmlDocument.value('(/StockItems/Item/IsChillerStock)[1]', 'BIT'),
	@xmlDocument.value('(/StockItems/Item/TaxRate)[1]', 'DECIMAL(18,3)'),
	@xmlDocument.value('(/StockItems/Item/UnitPrice)[1]', 'DECIMAL(18, 2)')


	EXEC sp_xml_removedocument @docHandle;

	MERGE Warehouse.StockItems AS wsi
    USING (SELECT StockItemName,
	SupplierID,
	UnitPackageID, OuterPackageID, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice from #Items) AS src(StockItemName, SupplierID, UnitPackageID,
	OuterPackageID, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice)
        ON (wsi.StockItemName = src.StockItemName)
    WHEN MATCHED
        THEN
            UPDATE
            SET SupplierID = scr.SupplierID,
	UnitPackageID = src.UnitPackageID,
	OuterPackageID = scr.OuterPackageID,
	LeadTimeDays = scr.LeadTimeDays,
	IsChillerStock = src.IsChillerStock,
	TaxRate = src.TaxRate,
	UnitPrice = src.UnitPrice
   WHEN NOT MATCHED
        THEN
            INSERT (StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice)
            VALUES (src.StockItemName, src.SupplierID, src.UnitPackageID, src.OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice)
;

2. SELECT TOP 10 [StockItemName] as '@Name',
	[SupplierID],
	(select [UnitPackageID],
	[OuterPackageID],
	[QuantityPerOuter],
	[TypicalWeightPerUnit]
	FROM Warehouse.StockItems w
	where s.StockItemName=  w.StockItemName
FOR xml path('Package'), type),
	[LeadTimeDays],
	[IsChillerStock],
	[TaxRate],
	[UnitPrice]
FROM Warehouse.StockItems s
FOR xml path('Item'), ROOT ('StockItems')

3. 


SELECT distinct StockItemID,
StockItemName,
JSON_VALUE(CustomFields,'$.CountryOfManufacture') as CountryOfManufacture,
JSON_VALUE(CustomFields, '$.Tags[0]') as FirstTag
from Warehouse.StockItems
cross apply OPENJSON(CustomFields) AS j;

4. 
SELECT
StockItemID,
StockItemName
from Warehouse.StockItems
cross apply OPENJSON(CustomFields, '$.Tags') AS j
WHERE j.value = 'Vintage';
