use Service

--�������� �������� ������
ALTER DATABASE [Service] ADD FILEGROUP [YearData]
GO

--��������� ���� ��
ALTER DATABASE [Service] ADD FILE 
( NAME = N'Years', FILENAME = N'D:\1\mssql\Yeardata.ndf' , 
SIZE = 1097152KB , FILEGROWTH = 65536KB ) TO FILEGROUP [YearData]
GO

--������� ������� ����������������� �� ����� - �� ��������� left!!
CREATE PARTITION FUNCTION [fnYearPartition](DATE) AS RANGE RIGHT FOR VALUES
('20120101','20130101','20140101','20150101','20160101', '20170101',
 '20180101', '20190101', '20200101', '20210101');																																																									
GO

-- ��������������, ��������� ��������� �������
CREATE PARTITION SCHEME [schmYearPartition] AS PARTITION [fnYearPartition] 
ALL TO ([YearData])
GO


SELECT count(*) 
FROM CarVisit;

--������� ������� ��� ���������������� 
SELECT * INTO CarVisitPartitioned
FROM CarVisit;

-- �� ������������ ������� ���� ������� ���������� ������ � ������� ����� ���������� ������ � ������ ���������������
-- ����� ������� ����� �������� ������� -> ���������

--�������� ����� ������������������ �������
CREATE TABLE [CarVisitYears](
	[ID] [int] NOT NULL,
	[CarID] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[TotalAmount] [money] NOT NULL,
	[AmountConfirmedForProcessing] [datetime] NULL
) ON [schmYearPartition]([Date])---� ����� [schmYearPartition] �� ����� [Date]
GO

--�������� ���������� ������ � ��� �� ����� � ��� �� ������
ALTER TABLE [CarVisitYears] ADD CONSTRAINT PK_CarVisitYears 
PRIMARY KEY CLUSTERED  (Date, Id)
 ON [schmYearPartition]([Date]);

--�������� 2 ������ ������
Alter Partition Function fnYearPartition() MERGE RANGE ('20120101');

--�������� ������
Alter Partition Function fnYearPartition() SPLIT RANGE ('20140701');	

--Alter Partition Function fnYearPartition() MERGE RANGE ('20140701');

--�������� ������
Alter Partition Function fnYearPartition() SPLIT RANGE ('20120101');	

--����������� �������� 
TRUNCATE TABLE CarVisitYears
WITH (PARTITIONS (4));

-- ����������� ����� �������� ��� ����������� ��������
ALTER PARTITION SCHEME [schmYearPartition]  
NEXT USED [YearData]; 