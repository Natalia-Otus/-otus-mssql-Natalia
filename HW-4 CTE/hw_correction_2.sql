

¬ыберите города (ид и название), в которые были доставлены товары, 
вход€щие в тройку самых дорогих товаров, а также им€ сотрудника, 
который осуществл€л упаковку заказов (PackedByPersonID).
*/

select ac.CityID, ac.CityName, ap.FullName
from Application.Cities ac
join Sales.Customers sc on sc.PostalCityID = ac.CityID
join Sales.Invoices si on sc.CustomerID = si.CustomerID
join Sales.InvoiceLines sil on si.InvoiceID = sil.InvoiceID and sil.StockItemID in 
(
select top(3) StockItemID
from Warehouse.StockItems
order by UnitPrice desc
)
join Application.People ap on si.PackedByPersonID = ap.PersonID
