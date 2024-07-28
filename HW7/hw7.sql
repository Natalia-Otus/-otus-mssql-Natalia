-- Требуется написать запрос, который в результате своего выполнения
-- формирует сводку по количеству покупок в разрезе клиентов и месяцев.
SELECT InvoiceMonth as 'InvoiceMonth',   
[Gasport, NY],
[Jessie, ND],
[Medicine Lodge, KS],
[Peeples Valley, AZ],
[Sylvanite, MT] 
FROM  
( 
SELECT left(right(sc.CustomerName, (len(sc.CustomerName)-15)), len(sc.CustomerName)-16) as 'CustomerName', so.OrderID as 'OrderID', 
  format(DATEFROMPARTS(YEAR(so.orderdate),MONTH(so.orderdate),1), 'dd.MM.yyyy') as 'InvoiceMonth' 
  FROM Sales.Orders so
  join Sales.Customers sc on sc.CustomerID = so.CustomerID
  where sc.CustomerID in (2, 3, 4, 5, 6)
) AS SourceTable  
PIVOT  
(  
  count(OrderID)
  FOR CustomerName in( [Gasport, NY],
[Jessie, ND],
[Medicine Lodge, KS],
[Peeples Valley, AZ],
[Sylvanite, MT] ) 
) AS PivotTable; -- Pivot table with one row and five columns  

--Для всех клиентов с именем, в котором есть "Tailspin Toys"
--вывести все адреса, которые есть в таблице, в одной колонке.

SELECT sc.CustomerName, DeliveryAddressLine1
FROM sales.customers sc
where sc.CustomerID in (2, 3, 4, 5, 6)
union 
SELECT sc.CustomerName,DeliveryAddressLine2 
FROM sales.customers sc
where sc.CustomerID in (2, 3, 4, 5, 6)
union 
SELECT sc.CustomerName, PostalAddressLine1 
FROM sales.customers sc
where sc.CustomerID in (2, 3, 4, 5, 6)
union
SELECT sc.CustomerName, PostalAddressLine2
FROM sales.customers sc
where sc.CustomerID in (2, 3, 4, 5, 6)

--В таблице стран (Application.Countries) есть поля с цифровым кодом страны и с буквенным.
--Сделайте выборку ИД страны, названия и ее кода так, 
--чтобы в поле с кодом был либо цифровой либо буквенный код.

select CountryID, CountryName, IsoAlpha3Code from Application.Countries
union
select CountryID, CountryName, cast(IsoNumericCode as varchar(30)) from Application.Countries
order by CountryName

--Выберите по каждому клиенту два самых дорогих товара, которые он покупал.
--В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки.
select sc.CustomerID, sc.CustomerName, c.StockItemID, c.UnitPrice, c.OrderDate
from Sales.Customers sc
cross apply (select top(2) sol.StockItemID as 'StockItemID', sol.UnitPrice as 'UnitPrice', so.OrderDate as 'OrderDate'
from Sales.Orders so
join Sales.OrderLines sol on so.OrderID = sol.OrderID
where so.CustomerID = sc.CustomerID
order by sol.UnitPrice desc) as c
