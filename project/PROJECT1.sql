use Service
select c.Brand, c.Model, cv.TotalAmount
from Cars c
join CarVisit cv on c.CarID = cv.CarID
where cv.Date > '2024-09-01'



insert into Cars (CarID, Brand, Model, ReleaseDate, Owner, PhoneNumber, CarNumber)
values (3, 'Volvo', 'X80', '2022-10-10', 'Sidoroov', '89937', '“123Õ–199')

insert into CarVisit (ID, CarID, date, TotalAmount)
values (1, 1, '2024-10-10', '10000'),
(2, 2, '2024-10-10', '11000')

INSERT INTO WORKS 
VALUES (1, 'Á¿Ã≈Õ¿ Ã¿—À¿', 3000)

INSERT INTO WORKS 
VALUES (2, '—Ã≈Õ¿ ‘»À‹“–¿', 2500)


INSERT INTO MASTERS
VALUES (1, '»¬¿Õ', '»¬¿ÕŒ¬»◊', '»¬¿ÕŒ¬')

INSERT INTO WorksOfMasters
VALUES (1, 1, 1), (2, 1, 2)

SELECT * FROM GetAllWorksForCar(1)

SELECT * FROM CARS
SELECT * FROM CarVisit
SELECT * FROM CarWorks

INSERT INTO CarWorks
VALUES (1, 1, 1, 1), (2, 1, 2, 1)

alter table dbo.Cars
add CarNumber varchar(30) null