--—оздать базу данных.

CREATE DATABASE Service;
GO

--3-4 основные таблицы дл€ своего проекта.

CREATE TABLE [Masters] (
    [MasterID] int  NOT NULL ,
    [Name] varchar(60)  NOT NULL ,
    [SecondName] varchar(60)  NOT NULL ,
    [Surname] varchar(60)  NOT NULL ,
    CONSTRAINT [PK_Masters] PRIMARY KEY CLUSTERED (
        [MasterID] ASC
    )
)
 
CREATE TABLE [Works] (
    [WorkID] int  NOT NULL ,
    [NameOfWork] varchar(100)  NOT NULL ,
    [Cost] money  NOT NULL ,
    CONSTRAINT [PK_Works] PRIMARY KEY CLUSTERED (
        [WorkID] ASC
    )
)
 
CREATE TABLE [WorksOfMasters] (
    [ID] int  NOT NULL ,
    [MasterID] int  NOT NULL ,
    [WorkID] int  NOT NULL ,
    CONSTRAINT [PK_WorksOfMasters] PRIMARY KEY CLUSTERED (
        [ID] ASC
    )
)
 
CREATE TABLE [Cars] (
    [CarID] int  NOT NULL ,
    [Brand] varchar(60)  NOT NULL ,
    [Model] varchar(60)  NOT NULL ,
    [ReleaseDate] date  NOT NULL ,
    [Owner] varchar(150)  NOT NULL ,
    [PhoneNumber] varchar(30)  NOT NULL ,
    CONSTRAINT [PK_Cars] PRIMARY KEY CLUSTERED (
        [CarID] ASC
    )
)
--ѕервичные и внешние ключи дл€ всех созданных таблиц.
--1-2 индекса на таблицы.

ALTER TABLE [WorksOfMasters] WITH CHECK ADD CONSTRAINT [FK_WorksOfMasters_MasterID] FOREIGN KEY([MasterID])
REFERENCES [Masters] ([MasterID])
 
ALTER TABLE [WorksOfMasters] CHECK CONSTRAINT [FK_WorksOfMasters_MasterID]
 
ALTER TABLE [WorksOfMasters] WITH CHECK ADD CONSTRAINT [FK_WorksOfMasters_WorkID] FOREIGN KEY([WorkID])
REFERENCES [Works] ([WorkID])
 
ALTER TABLE [WorksOfMasters] CHECK CONSTRAINT [FK_WorksOfMasters_WorkID]
 
ALTER TABLE [CarVisit] WITH CHECK ADD CONSTRAINT [FK_CarVisit_CarID] FOREIGN KEY([CarID])
REFERENCES [Cars] ([CarID])
 

--Ќаложите по одному ограничению в каждой таблице на ввод данных.

ALTER TABLE Cars
	ADD CONSTRAINT constr_dReleaseDate
		CHECK (datediff(yy, ReleaseDate, getdate()) <=5);