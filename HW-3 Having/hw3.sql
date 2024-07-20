--Ќапишите выборки дл€ того, чтобы получить:

--ѕосчитать среднюю цену товара, общую сумму продажи по мес€цам.

-- средн€€ цена из всех товаров, которые были проданы
select avg(sol.unitprice)
from sales.orderlines sol 

-- сумма продаж в каждый мес€ц
select sum(sol.unitprice*sol.Quantity) as 'ќбща€ сумма продаж за мес€ц', 
 avg(sol.unitprice*sol.Quantity) as '—редн€€ цена за мес€ц по всем товарам',
DATEPART(MONTH, so.orderdate) as 'ћес€ц продажи',
DATEPART(YEAR, so.orderdate) as '√од продажи' 
from sales.orderlines sol 
join sales.orders so on sol.OrderID = so.OrderID
group by DATEPART(YEAR, so.orderdate), DATEPART(MONTH, so.orderdate)




--ќтобразить все мес€цы, где обща€ сумма продаж превысила 4 600 000.
select sum(sol.unitprice*sol.Quantity) as 'ќбща€ сумма продаж', DATEPART(MONTH, so.orderdate) as 'ћес€ц', 
DATEPART(YEAR, so.orderdate) as '√од'
from sales.orderlines sol 
join sales.orders so on sol.OrderID = so.OrderID
group by DATEPART(YEAR, so.orderdate), DATEPART(MONTH, so.orderdate)
having sum(sol.unitprice*sol.Quantity) > 4600000


--¬ывести сумму продаж, дату первой продажи и количество проданного по мес€цам, по товарам, продажи которых менее 50 ед в мес€ц.
--√руппировка должна быть по году, мес€цу, товару.

select si.StockItemID, DATEPART(YEAR, i.invoicedate), DATEPART(MONTH, i.invoicedate),
sum(si.Quantity), min(i.invoicedate)
from Sales.InvoiceLines si
join Sales.invoices i on si.invoiceid = i.invoiceid
group by si.StockItemID, DATEPART(YEAR, i.invoicedate), DATEPART(MONTH, i.invoicedate)
having sum(si.Quantity) < 50



