-- 1
select * 
from warehouse.StockItems 
where StockItemName like '%urgent%' 
      or StockItemName like 'Animal%'

-- 2
select S.* 
from Purchasing.Suppliers S
left join Purchasing.PurchaseOrders PO on S.SupplierID = PO.SupplierID
where PO.SupplierID is null

-- 3
select SO.* 
from Sales.Orders SO 
join Sales.OrderLines SOL on SO.OrderID = SOL.OrderID 
where (SOL.UnitPrice > 100 or SOL.Quantity > 20) 
     and SOL.PickingCompletedWhen is not null

-- 4
select PSO.*
from Purchasing.PurchaseOrders PSO 
join Application.DeliveryMethods ADM on PSO.DeliveryMethodID = ADM.DeliveryMethodID
where (year(PSO.ExpectedDeliveryDate) = 2013 and  month(PSO.ExpectedDeliveryDate) = 1) 
		and ADM.DeliveryMethodName in ('Air Freight', 'Refrigerated Air Freight')
		and PSO.IsOrderFinalized = 1

-- 5
select top(10) with ties SA.*, SC.CustomerName, AP.FullName
from Sales.Orders SA
join Sales.Customers SC on SA.CustomerID = SC.CustomerID
join Application.People AP on SA.SalespersonPersonID = AP.PersonID
order by SA.OrderDate desc

-- 6
select distinct (SC.CustomerID), SC.CustomerName, SC.PhoneNumber
from Sales.Orders SO
join Sales.OrderLines SOL on SO.OrderID = SOL.OrderID
join Sales.Customers SC on SO.CustomerID = SC.CustomerID
where SOL.Description = 'Chocolate frogs 250g'