/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "03 - Подзапросы, CTE, временные таблицы".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- Для всех заданий, где возможно, сделайте два варианта запросов:
--  1) через вложенный запрос
--  2) через WITH (для производных таблиц)
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
1. Выберите сотрудников (Application.People), которые являются продажниками (IsSalesPerson), 
и не сделали ни одной продажи 04 июля 2015 года. 
Вывести ИД сотрудника и его полное имя. 
Продажи смотреть в таблице Sales.Invoices.
*/

TODO: напишите здесь свое решение

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
2. Выберите товары с минимальной ценой (подзапросом). Сделайте два варианта подзапроса. 
Вывести: ИД товара, наименование товара, цена.
*/

TODO: напишите здесь свое решение

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
3. Выберите информацию по клиентам, которые перевели компании пять максимальных платежей 
из Sales.CustomerTransactions. 
Представьте несколько способов (в том числе с CTE). 
*/

TODO: напишите здесь свое решение

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



-- не нашла, где храниться PickedByPersonID (подозреваю что должен быть в заказе), вывела вместо этого сотрудника, который доставлял PickedByPersonID


/*
4. Выберите города (ид и название), в которые были доставлены товары, 
входящие в тройку самых дорогих товаров, а также имя сотрудника, 
который осуществлял упаковку заказов (PackedByPersonID).
*/

TODO: напишите здесь свое решение

-- ---------------------------------------------------------------------------
-- Опциональное задание
-- ---------------------------------------------------------------------------
-- Можно двигаться как в сторону улучшения читабельности запроса, 
-- так и в сторону упрощения плана\ускорения. 
-- Сравнить производительность запросов можно через SET STATISTICS IO, TIME ON. 
-- Если знакомы с планами запросов, то используйте их (тогда к решению также приложите планы). 
-- Напишите ваши рассуждения по поводу оптимизации. 

-- 5. Объясните, что делает и оптимизируйте запрос

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

TODO: напишите здесь свое решение
