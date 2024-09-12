1.

CREATE FUNCTION dbo.CustomerMaxPurchase ()
RETURNS INT

AS
BEGIN
    DECLARE @CustomerID INT;
    
	select @CustomerID =  SI.CustomerID 
	from Sales.Invoices SI
	where SI.InvoiceID = (
	select top(1) SL.Invoiceid
	from Sales.InvoiceLines SL
	group by SL.InvoiceID
	order by sum(SL.Quantity*sl.UnitPrice) desc);

    RETURN (@CustomerID);
END;
GO

select dbo.CustomerMaxPurchase ()

2.
go
create or alter procedure dbo.CustomerPurchase
@CustomerID int
as 
begin

select sum(SL.Quantity*sl.UnitPrice)
	from Sales.InvoiceLines SL
	join Sales.Invoices SI on SL.InvoiceID = SI.InvoiceID
	where SI.CustomerID = @CustomerID ;

end;
go

exec dbo.CustomerPurchase
@CustomerID = 10

3.
CREATE or alter FUNCTION dbo.MostExpensiveItemInPurchase (@CustomerID int)
RETURNS INT

AS
BEGIN
    DECLARE @ItemID INT;
    
	select top(1) @ItemID = SL.StockItemID
	from Sales.InvoiceLines SL
	join Sales.Invoices SI on SL.InvoiceID = SI.InvoiceID
	where SI.CustomerID = @CustomerID
	order by SL.UnitPrice desc;

    RETURN (@ItemID);
END;
GO



go
create or alter procedure dbo.MostExpensiveItemInPurchases
@CustomerID int
as 
begin

select top(1) SL.StockItemID
	from Sales.InvoiceLines SL
	join Sales.Invoices SI on SL.InvoiceID = SI.InvoiceID
	where SI.CustomerID = @CustomerID
	order by SL.UnitPrice desc;

end;
go


select dbo.MostExpensiveItemInPurchase (10)
exec dbo.MostExpensiveItemInPurchases @CustomerID = 10

-- по плану выполнения процедура дольше

4.
CREATE or alter FUNCTION dbo.ItemsOfCustomer (@CustomerID int)
RETURNS table

AS
return

    
	select  distinct SL.StockItemID
	from Sales.InvoiceLines SL
	join Sales.Invoices SI on SL.InvoiceID = SI.InvoiceID
	where SI.CustomerID = @CustomerID;


GO

select *
from Warehouse.StockItems s
join dbo.ItemsOfCustomer (10) i on s.StockItemID = i.StockItemID