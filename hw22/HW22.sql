use Service

--создадим файловую группу
ALTER DATABASE [Service] ADD FILEGROUP [YearData]
GO

--добавляем файл БД
ALTER DATABASE [Service] ADD FILE 
( NAME = N'Years', FILENAME = N'D:\1\mssql\Yeardata.ndf' , 
SIZE = 1097152KB , FILEGROWTH = 65536KB ) TO FILEGROUP [YearData]
GO

--создаем функцию партиционирования по годам - по умолчанию left!!
CREATE PARTITION FUNCTION [fnYearPartition](DATE) AS RANGE RIGHT FOR VALUES
('20120101','20130101','20140101','20150101','20160101', '20170101',
 '20180101', '20190101', '20200101', '20210101');																																																									
GO

-- партиционируем, используя созданную функцию
CREATE PARTITION SCHEME [schmYearPartition] AS PARTITION [fnYearPartition] 
ALL TO ([YearData])
GO


SELECT count(*) 
FROM CarVisit;

--создаем таблицу для секционированния 
SELECT * INTO CarVisitPartitioned
FROM CarVisit;

-- на существующей таблице надо удалить кластерный индекс и создать новый кластерный индекс с ключом секционирования
-- можно создать через свойства таблицы -> хранилище

--создадим новую партиционированную таблицу
CREATE TABLE [CarVisitYears](
	[ID] [int] NOT NULL,
	[CarID] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[TotalAmount] [money] NOT NULL,
	[AmountConfirmedForProcessing] [datetime] NULL
) ON [schmYearPartition]([Date])---в схеме [schmYearPartition] по ключу [Date]
GO

--создадим кластерный индекс в той же схеме с тем же ключом
ALTER TABLE [CarVisitYears] ADD CONSTRAINT PK_CarVisitYears 
PRIMARY KEY CLUSTERED  (Date, Id)
 ON [schmYearPartition]([Date]);

--смерджим 2 пустые секции
Alter Partition Function fnYearPartition() MERGE RANGE ('20120101');

--разделим секцию
Alter Partition Function fnYearPartition() SPLIT RANGE ('20140701');	

--Alter Partition Function fnYearPartition() MERGE RANGE ('20140701');

--разделим секцию
Alter Partition Function fnYearPartition() SPLIT RANGE ('20120101');	

--странкейтим партицию 
TRUNCATE TABLE CarVisitYears
WITH (PARTITIONS (4));

-- переключить схему хранения для последующих партиций
ALTER PARTITION SCHEME [schmYearPartition]  
NEXT USED [YearData]; 