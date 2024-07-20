--�������� ������� ��� ����, ����� ��������:

--��������� ������� ���� ������, ����� ����� ������� �� �������.

-- ������� ���� �� ���� �������, ������� ���� �������
select avg(sol.unitprice)
from sales.orderlines sol 

-- ����� ������ � ������ �����
select sum(sol.unitprice*sol.Quantity) as '����� ����� ������ �� �����', 
 avg(sol.unitprice*sol.Quantity) as '������� ���� �� ����� �� ���� �������',
DATEPART(MONTH, so.orderdate) as '����� �������',
DATEPART(YEAR, so.orderdate) as '��� �������' 
from sales.orderlines sol 
join sales.orders so on sol.OrderID = so.OrderID
group by DATEPART(YEAR, so.orderdate), DATEPART(MONTH, so.orderdate)




--���������� ��� ������, ��� ����� ����� ������ ��������� 4 600 000.
select sum(sol.unitprice*sol.Quantity) as '����� ����� ������', DATEPART(MONTH, so.orderdate) as '�����', 
DATEPART(YEAR, so.orderdate) as '���'
from sales.orderlines sol 
join sales.orders so on sol.OrderID = so.OrderID
group by DATEPART(YEAR, so.orderdate), DATEPART(MONTH, so.orderdate)
having sum(sol.unitprice*sol.Quantity) > 4600000


--������� ����� ������, ���� ������ ������� � ���������� ���������� �� �������, �� �������, ������� ������� ����� 50 �� � �����.
--����������� ������ ���� �� ����, ������, ������.

select si.StockItemID, DATEPART(YEAR, i.invoicedate), DATEPART(MONTH, i.invoicedate),
sum(si.Quantity), min(i.invoicedate)
from Sales.InvoiceLines si
join Sales.invoices i on si.invoiceid = i.invoiceid
group by si.StockItemID, DATEPART(YEAR, i.invoicedate), DATEPART(MONTH, i.invoicedate)
having sum(si.Quantity) < 50



