/*
�������� ������� �� ����� MS SQL Server Developer � OTUS.

������� "03 - ����������, CTE, ��������� �������".

������� ����������� � �������������� ���� ������ WideWorldImporters.

����� �� ����� ������� ������:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
����� WideWorldImporters-Full.bak

�������� WideWorldImporters �� Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- ������� - �������� ������� ��� ��������� ��������� ���� ������.
-- ��� ���� �������, ��� ��������, �������� ��� �������� ��������:
--  1) ����� ��������� ������
--  2) ����� WITH (��� ����������� ������)
-- ---------------------------------------------------------------------------

USE WideWorldImporters

select ap.personid, ap.fullname
from application.people ap
where not exists
(select 1 from sales.invoices si where ap.personid = si.salespersonpersonid and si.invoicedate > '2015-07-04')
and ap.issalesperson = 1 

; with cte as (
select distinct si.salespersonpersonid 
from sales.invoices si
where si.invoicedate > '2015-07-04'
)

select ap.personid, ap.fullname
from application.people ap
left join cte c on ap.personid = c.salespersonpersonid 
where ap.issalesperson = 1 
and c.SalespersonPersonID is null

/*
1. �������� ����������� (Application.People), ������� �������� ������������ (IsSalesPerson), 
� �� ������� �� ����� ������� 04 ���� 2015 ����. 
������� �� ���������� � ��� ������ ���. 
������� �������� � ������� Sales.Invoices.
*/

TODO: �������� ����� ���� �������

select si.stockitemid, si.StockItemName, si.UnitPrice
from Warehouse.StockItems si
where si.UnitPrice = (select min(UnitPrice) from Warehouse.StockItems)

; with cte as (
select min(UnitPrice) as UnitPrice
from Warehouse.StockItems
)

select si.stockitemid, si.StockItemName, si.UnitPrice
from Warehouse.StockItems si
join cte c on si.UnitPrice = c.UnitPrice


/*
2. �������� ������ � ����������� ����� (�����������). �������� ��� �������� ����������. 
�������: �� ������, ������������ ������, ����.
*/

TODO: �������� ����� ���� �������

; with cte (Payment) as 
(
select top(5) TransactionAmount
from Sales.CustomerTransactions
order by TransactionAmount desc
)

select cs.*
from Sales.CustomerTransactions ct
join Sales.Customers cs on ct.CustomerID = cs.CustomerID
join cte c on ct.TransactionAmount = c.Payment

select cs.*
from Sales.CustomerTransactions ct
join Sales.Customers cs on ct.CustomerID = cs.CustomerID
where ct.TransactionAmount in (select top(5) TransactionAmount
from Sales.CustomerTransactions
order by TransactionAmount desc)

select cs.*
from Sales.CustomerTransactions ct
join Sales.Customers cs on ct.CustomerID = cs.CustomerID
join (select top(5) TransactionAmount
from Sales.CustomerTransactions
order by TransactionAmount desc) c on ct.TransactionAmount = c.TransactionAmount

/*
3. �������� ���������� �� ��������, ������� �������� �������� ���� ������������ �������� 
�� Sales.CustomerTransactions. 
����������� ��������� �������� (� ��� ����� � CTE). 
*/

TODO: �������� ����� ���� �������

select ac.CityID, ac.CityName, ap.FullName
from Application.Cities ac
join Sales.Customers sc on sc.PostalCityID = ac.CityID
join Sales.Orders so on sc.CustomerID = so.CustomerID
join Application.People ap on ap.personid = so.PickedByPersonID
join Sales.OrderLines li on so.OrderID = li.OrderID
join Warehouse.StockItems si on li.StockItemID = si.StockItemID and si.StockItemID in 
(
select top(3) StockItemID
from Warehouse.StockItems
order by UnitPrice
)

; with cte as (
select top(3) StockItemID
from Warehouse.StockItems
order by UnitPrice
)

select ac.CityID, ac.CityName, ap.FullName
from Application.Cities ac
join Sales.Customers sc on sc.PostalCityID = ac.CityID
join Sales.Orders so on sc.CustomerID = so.CustomerID
join Application.People ap on ap.personid = so.PickedByPersonID
join Sales.OrderLines li on so.OrderID = li.OrderID
join Warehouse.StockItems si on li.StockItemID = si.StockItemID 
join cte c on  si.StockItemID = c.StockItemID 



-- �� �����, ��� ��������� PickedByPersonID (���������� ��� ������ ���� � ������), ������ ������ ����� ����������, ������� ��������� PickedByPersonID


/*
4. �������� ������ (�� � ��������), � ������� ���� ���������� ������, 
�������� � ������ ����� ������� �������, � ����� ��� ����������, 
������� ����������� �������� ������� (PackedByPersonID).
*/

TODO: �������� ����� ���� �������

-- ---------------------------------------------------------------------------
-- ������������ �������
-- ---------------------------------------------------------------------------
-- ����� ��������� ��� � ������� ��������� ������������� �������, 
-- ��� � � ������� ��������� �����\���������. 
-- �������� ������������������ �������� ����� ����� SET STATISTICS IO, TIME ON. 
-- ���� ������� � ������� ��������, �� ����������� �� (����� � ������� ����� ��������� �����). 
-- �������� ���� ����������� �� ������ �����������. 

-- 5. ���������, ��� ������ � ������������� ������

SELECT 
	Invoices.InvoiceID, 
	Invoices.InvoiceDate,
	(SELECT People.FullName
		FROM Application.People
		WHERE People.PersonID = Invoices.SalespersonPersonID
	) AS SalesPersonName,
	SalesTotals.TotalSumm AS TotalSummByInvoice, 
	(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
		FROM Sales.OrderLines
		WHERE OrderLines.OrderId = (SELECT Orders.OrderId 
			FROM Sales.Orders
			WHERE Orders.PickingCompletedWhen IS NOT NULL	
				AND Orders.OrderId = Invoices.OrderId)	
	) AS TotalSummForPickedItems
FROM Sales.Invoices 
	JOIN
	(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
	FROM Sales.InvoiceLines
	GROUP BY InvoiceId
	HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
		ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC

-- --

TODO: �������� ����� ���� �������
