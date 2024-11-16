-- запрос на работы, которые производились по одному автомобилю (поиск по номеру телефона владельца)
select c.*, w.NameOfWork 
from dbo.CarWorks cw
join dbo.Works w on cw.WorkID = w.workID
join dbo.CarVisit cv on cw.CarVisitID = cv.ID
join dbo.Cars c on cv.carID = c.CarID
where C.PhoneNumber = ''

exec sp_helpindex CarWorks

create index x1_CarWorks_workID on CarWorks (workID)
create index x1_CarWorks_CarVisitID on CarWorks (CarVisitID)

exec sp_helpindex Works

create index x1_Works_NameOfWork on Works (NameOfWork)

exec sp_helpindex CarVisit

create clustered index PK on CarVisit (ID)
create index x1_CarVisit_CarID on CarVisit (CarID)

exec sp_helpindex Cars

create index x1_Cars_PhoneNumber on Cars (PhoneNumber)

-- запрос на работы. которые делались одним мастером (будем искать по фамилии)

select M.*, w.NameOfWork 
from dbo.Masters M
join dbo.CarWorks cw on cw.MasterID = M.MasterID
join dbo.Works w on cw.WorkID = w.workID
where M.Surname = ''

exec sp_helpindex Masters

create index x1_Masters_Surname on Masters (Surname)

exec sp_helpindex CarWorks

create index x1_CarWorks_MasterID on CarWorks (MasterID)

exec sp_helpindex Works