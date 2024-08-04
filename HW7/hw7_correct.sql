

--��� ���� �������� � ������, � ������� ���� "Tailspin Toys"
--������� ��� ������, ������� ���� � �������, � ����� �������.



SELECT CustomerName, DeliveryAddress
FROM (SELECT CustomerName, DeliveryAddressLine1,
DeliveryAddressLine2,
PostalAddressLine1,
PostalAddressLine2
FROM sales.customers where CustomerID in (2, 3, 4, 5, 6)) AS p
UNPIVOT (DeliveryAddress FOR CustomerName IN ([Tailspin Toys (Gasport, NY)],
 [Tailspin Toys (Jessie, ND)],
[Tailspin Toys (Medicine Lodge, KS)], [Tailspin Toys (Peeples Valley, AZ)], [Tailspin Toys (Sylvanite, MT)]))
AS s


--� ������� ����� (Application.Countries) ���� ���� � �������� ����� ������ � � ���������.
--�������� ������� �� ������, �������� � �� ���� ���, 
--����� � ���� � ����� ��� ���� �������� ���� ��������� ���.



SELECT CountryID, CountryName, IsoAlphaCode
FROM (SELECT CCountryID, CountryName, IsoAlphaCode, cast(IsoNumericCode as varchar(30)) from Application.Countries) AS p
UNPIVOT (IsoAlphaCode FOR CountryID IN ([1],
 [2],
[3], [4], [5]))
AS s

