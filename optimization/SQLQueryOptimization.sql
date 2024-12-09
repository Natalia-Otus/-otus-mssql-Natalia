; with #cte as (SELECT ordTotal.CustomerID
	FROM Sales.OrderLines AS Total
		Join Sales.Orders AS ordTotal
	On ordTotal.OrderID = Total.OrderID
	group by ordTotal.CustomerID
	having SUM(Total.UnitPrice*Total.Quantity) > 250000)


Select ord.CustomerID, det.StockItemID, SUM(det.UnitPrice), SUM(det.Quantity), COUNT(ord.OrderID)    
FROM Sales.Orders AS ord
    JOIN Sales.OrderLines AS det
        ON det.OrderID = ord.OrderID
    JOIN Sales.Invoices AS Inv 
        ON Inv.OrderID = ord.OrderID
    JOIN Sales.CustomerTransactions AS Trans
        ON Trans.InvoiceID = Inv.InvoiceID
    JOIN Warehouse.StockItemTransactions AS ItemTrans
        ON ItemTrans.StockItemID = det.StockItemID
	JOIN #cte c on c.CustomerID = Inv.CustomerID
	JOIN Warehouse.StockItems AS It on It.StockItemID = det.StockItemID and It.SupplierId = 12
WHERE Inv.BillToCustomerID != ord.CustomerID 
    AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
GROUP BY ord.CustomerID, det.StockItemID
ORDER BY ord.CustomerID, det.StockItemID
