USE [Service]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER FUNCTION [dbo].[GetAllWorksForCar]
    (@CarID as int)
RETURNS TABLE
AS RETURN
(
SELECT  
C.Brand, C.Model, CV.Date, W.NameOfWork
FROM [Cars] C
join [CarVisit] CV on C.CarID = CV.CarID
join [CarWorks] CW on CV.ID = CW.CarVisitID
join [Works] W on CW.WorkID = W.WorkID
WHERE C.CarID = @CarID
)
GO



USE [Service]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[InsertCarVisit]
@CarNumber varchar(30)

AS
BEGIN
    DECLARE @ID int,
     @CarID int,
     @dt datetime = getdate()

	if not exists (select 1 from dbo.Cars where CarNumber = @CarNumber)
	begin
	   print 'Ќомер указан неверно или такого номера нет в базе'
	   return
	end

	select @ID = max(ID)+1 from dbo.CarVisit
	select @CarID = @ID from dbo.Cars where CarNumber = @CarNumber

	insert into dbo.CarVisit (ID, CarID, date)
    values (@id, @CarID, @dt)

END
GO