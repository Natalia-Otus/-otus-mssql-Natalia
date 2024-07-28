--������� ������ ����� ������ ����������� ������ �� ������� � 2015 ����
--(� ������ ������ ������ �� ����� ����������, ��������� ����� � ������� ������� �������).

select datepart (month, ol.PickingCompletedWhen),
(select		  sum(UnitPrice*PickedQuantity) 
								from  sales.OrderLines OL2 
								where OL.OrderId=OL2.OrderId 
								  and datepart (month, ol.PickingCompletedWhen)<=datepart (month, ol2.PickingCompletedWhen))
from Sales.OrderLines ol
where datepart(year, PickingCompletedWhen) = 2015
order by 1,2;

--����������� ���� ������ ���� ��� ������� �������.
--�������� ������ ����� ����������� ������ � ���������� ������� � ������� ������� �������.

select OrderId,
	OrderLineId as OLid,
datepart (month, PickingCompletedWhen),
sum(Quantity*UnitPrice) over (partition by datepart(month, PickingCompletedWhen) order by OrderLineID) as sum_by_month
from Sales.OrderLines
where datepart(year, PickingCompletedWhen) = 2015;

--�������� ������������������ �������� 1 � 2 � ������� set statistics time, io on

-- � ����������� ������� ������� �������

--������� ������ 2� ����� ���������� ��������� (�� ���������� ���������)
--� ������ ������ �� 2016 ��� (�� 2 ����� ���������� �������� � ������ ������).

-- � ������� �������� �� ���������� �� �����, ������� ������ ������� ���������
;with cte as 
(
select datepart (month, ol.PickingCompletedWhen) as d
, ol.StockItemID, si.StockItemName
 , rank() over (partition  by datepart (month, ol.PickingCompletedWhen) order by ol.PickedQuantity desc) as r
 --,row_number() over (partition by datepart (month, ol.PickingCompletedWhen) order by quantity desc) as r
 from sales.orderlines ol 
 join  Warehouse.StockItems si on ol.StockItemID = si.StockItemID
 where datepart(year, PickingCompletedWhen) = 2016
 )
 select * from cte where r in (1, 2)

 -- ������ ����� �������

drop table if exists #tmp
select datepart (month, ol.PickingCompletedWhen) as d
, ol.StockItemID as o
 , sum(quantity) over (partition by datepart (month, ol.PickingCompletedWhen), stockitemid) as q
 --rank() over (partition by OL.OrderId order by UnitPrice*PickedQuantity desc)
 --,row_number() over (partition by datepart (month, ol.PickingCompletedWhen) order by quantity desc) as r
 into #tmp
 from sales.orderlines ol 
 where datepart(year, PickingCompletedWhen) = 2016;
 --select distinct d, o, q 
 --from #tmp order by d, q desc

declare @i int
set @i = 1
 while @i < 12
 begin
select distinct top(2) o as 'ID ������', q as '���-�� ����������'
 from #tmp
 where d = @i
 order by q desc

 set @i = @i + 1
 end



--������� ����� ��������
--���������� �� ������� ������� (� ����� ����� ������ ������� �� ������, ��������, ����� � ����):
--������������ ������ �� �������� ������, ��� ����� ��� ��������� ����� �������� ��������� ���������� ������
--���������� ����� ���������� ������� � �������� ����� � ���� �� �������
--���������� ����� ���������� ������� � ����������� �� ������ ����� �������� ������
--���������� ��������� id ������ ������ �� ����, ��� ������� ����������� ������� �� �����
--���������� �� ������ � ��� �� �������� ����������� (�� �����)
--�������� ������ 2 ������ �����, � ������ ���� ���������� ������ ��� ����� ������� "No items"
--����������� 30 ����� ������� �� ���� ��� ������ �� 1 ��

select StockItemID, StockItemName,Brand, UnitPrice,
rank() over (partition by left(StockItemName, 1) order by StockItemName),
count(StockItemID) over (),
count(StockItemID) over (partition by left(StockItemName, 1)),
lead(StockItemID,1) over (order by StockItemName asc),
lag(StockItemID,1) over (order by StockItemName asc),
isnull((lag(StockItemName, 2)over (order by StockItemName asc)), 'No items')
,NTILE (30) OVER (order by TypicalWeightPerUnit desc) 
from Warehouse.StockItems 

--��� ���� ������ �� ����� ������ ������ ��� ������������� �������.
--�� ������� ���������� �������� ���������� �������, �������� ��������� ���-�� ������.
--� ����������� ������ ���� �� � ������� ����������, �� � �������� �������, ���� �������, ����� ������.
--�������� �� ������� ������� ��� ����� ������� ������, ������� �� �������.
--� ����������� ������ ���� �� ������, ��� ��������, �� ������, ����, ���� �������.

;with cte as (
select ap.personid, ap.fullname, cs.CustomerName, so.orderdate,
sum(sol.unitprice*sol.quantity) over (partition by so.orderid) as SumOfOrder,
row_number() over (partition by ap.personid order by so.orderdate desc) as r
from application.People ap
join sales.orders so on ap.personid = so.SalespersonPersonID
join sales.Customers cs on so.CustomerID = cs.CustomerID
join sales.orderlines sol on so.orderid = sol.OrderID
)

select * from cte where r = 1

; with cte as (
select so.CustomerID, cs.CustomerName, sol.stockitemid, so.orderdate,
row_number() over (partition by cs.CustomerID order by sol.unitprice desc) as r
from sales.orders so
join sales.Customers cs on so.CustomerID = cs.CustomerID
join sales.orderlines sol on so.orderid = sol.OrderID
)

select c.*, s.StockItemName
from cte c 
join warehouse.StockItems s on c.StockItemID = s.StockItemID
where c.r in (1, 2)