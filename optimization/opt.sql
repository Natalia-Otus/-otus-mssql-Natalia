
-- до оптимизации
SET STATISTICS TIME,IO ON

begin tran
select	(select S.Brief from dbo.Cell CL
		join dbo.Store S on CL.StoreID=S.ID
		where CIC.CellID=CL.ID),
		    CICE.ExemplarID, 
		C.DocDate,
			C.DocNumber,
			C.ConsigComment,
			C.SourceStoreID,
			(select CS.Name from dbo.ConsigStatus CS where C.ConsigStatusID=CS.ID),
			CT.Name
	from	dbo.ConsigItemCellExemplar CICE 
			join dbo.ConsigItemCell CIC on CICE.ConsigItemCellID=CIC.ID
			join dbo.ConsigItem CI on CIC.ConsigItemID=CI.ID
			join dbo.Consig C on CI.ConsigID=C.ID and C.ConsigTypeID in (7,8,22)
			join dbo.ConsigType CT on C.ConsigTypeID = CT.ID
			join dbo.Cell CL on CIC.CellID=CL.ID
	where	CL.PhysicalStoreID in (select PSA.PhysicalStoreID from PhysicalStoreAttribute PSA where CL.PhysicalStoreID = PSA.PhysicalStoreID and PSA.PhysicalStoreAttributeTypeID = 5 and isnull(PSA.[Value] , '') = '1') 
			and C.DocDate = '2024-11-15'
			and C.ConsigStatusID not in (23, 32, 79);
commit
-- после оптимизации
		SET STATISTICS TIME,IO ON
		select	CICE.ExemplarID,
		C.DocDate,
		C.DocNumber,
		CS.Name,
		C.ConsigComment,
		C.SourceStoreID,
		S.Brief,
		CT.Name
from	dbo.ConsigItemCellExemplar CICE 
		join dbo.ConsigItemCell CIC on CICE.ConsigItemCellID=CIC.ID
		join dbo.ConsigItem CI on CIC.ConsigItemID=CI.ID
		join dbo.Consig C on CI.ConsigID=C.ID
		join dbo.ConsigStatus CS on C.ConsigStatusID=CS.ID
		join dbo.ConsigType CT on C.ConsigTypeID = CT.ID
		join dbo.Cell CL on CIC.CellID=CL.ID
		join dbo.Store S on CL.StoreID=S.ID
where	C.ConsigTypeID in (7,8,22)
		and C.ConsigStatusID not in (23, 32, 79) -- Обработано
		and exists (select 1 from PhysicalStoreAttribute PSA where CL.PhysicalStoreID = PSA.PhysicalStoreID and PSA.PhysicalStoreAttributeTypeID = 5 and isnull(PSA.[Value] , '') = '1') 
		and C.DocDate = '2024-11-15';