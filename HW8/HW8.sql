--“ребуетс€ написать запрос, который в результате своего выполнени€
--формирует сводку по количеству покупок в разрезе клиентов и мес€цев.

--¬ строках должны быть мес€цы (дата начала мес€ца), в столбцах - клиенты.

--Ќужно написать запрос, который будет генерировать результаты дл€ всех клиентов.

--»м€ клиента указывать полностью из пол€ CustomerName.


DECLARE @dml AS NVARCHAR(MAX)
DECLARE @ColumnName AS NVARCHAR(MAX)
 
SELECT @ColumnName= ISNULL(@ColumnName + '],[','') 
       + CustomerName
FROM (SELECT DISTINCT CustomerName as CustomerName
         FROM Sales.Customers
		 group by CustomerName) as CustomerName


SELECT @ColumnName as ColumnName 

SET @dml = 
  N'SELECT InvoiceMonth , [' +@ColumnName + '] FROM 
( 
SELECT sc.CustomerName as CustomerName, so.OrderID as OrderID, 
  format(DATEFROMPARTS(YEAR(so.orderdate),MONTH(so.orderdate),1), ''dd.MM.yyyy'') as InvoiceMonth 
  FROM Sales.Orders so
  join Sales.Customers sc on sc.CustomerID = so.CustomerID
) AS SourceTable  
PIVOT  
(  
  count(OrderID)
  FOR CustomerName in ([' +@ColumnName + '])) AS PivotTable'


EXEC sp_executesql @dml

