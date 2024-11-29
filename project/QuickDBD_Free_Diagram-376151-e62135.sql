-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/lgEVpN
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


SET XACT_ABORT ON

BEGIN TRANSACTION QUICKDBD

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

CREATE TABLE [CarVisit] (
    [ID] int  NOT NULL ,
    [CarID] int  NOT NULL ,
    [Date] datetime  NOT NULL ,
    [TotalAmount] money  NOT NULL 
)

CREATE TABLE [CarWorks] (
    [ID] int  NOT NULL ,
    [CarVisitID] int  NOT NULL ,
    [WorkID] int  NOT NULL ,
    [MasterID] int  NOT NULL ,
    CONSTRAINT [PK_CarWorks] PRIMARY KEY CLUSTERED (
        [ID] ASC
    )
)

ALTER TABLE [WorksOfMasters] WITH CHECK ADD CONSTRAINT [FK_WorksOfMasters_MasterID] FOREIGN KEY([MasterID])
REFERENCES [Masters] ([MasterID])

ALTER TABLE [WorksOfMasters] CHECK CONSTRAINT [FK_WorksOfMasters_MasterID]

ALTER TABLE [WorksOfMasters] WITH CHECK ADD CONSTRAINT [FK_WorksOfMasters_WorkID] FOREIGN KEY([WorkID])
REFERENCES [Works] ([WorkID])

ALTER TABLE [WorksOfMasters] CHECK CONSTRAINT [FK_WorksOfMasters_WorkID]

ALTER TABLE [CarVisit] WITH CHECK ADD CONSTRAINT [FK_CarVisit_CarID] FOREIGN KEY([CarID])
REFERENCES [Cars] ([CarID])

ALTER TABLE [CarVisit] CHECK CONSTRAINT [FK_CarVisit_CarID]

ALTER TABLE [CarWorks] WITH CHECK ADD CONSTRAINT [FK_CarWorks_CarVisitID] FOREIGN KEY([CarVisitID])
REFERENCES [CarVisit] ([ID])

ALTER TABLE [CarWorks] CHECK CONSTRAINT [FK_CarWorks_CarVisitID]

ALTER TABLE [CarWorks] WITH CHECK ADD CONSTRAINT [FK_CarWorks_WorkID] FOREIGN KEY([WorkID])
REFERENCES [Works] ([WorkID])

ALTER TABLE [CarWorks] CHECK CONSTRAINT [FK_CarWorks_WorkID]

ALTER TABLE [CarWorks] WITH CHECK ADD CONSTRAINT [FK_CarWorks_MasterID] FOREIGN KEY([MasterID])
REFERENCES [Masters] ([MasterID])

ALTER TABLE [CarWorks] CHECK CONSTRAINT [FK_CarWorks_MasterID]

COMMIT TRANSACTION QUICKDBD