﻿use Service

-- Включаем CLR
exec sp_configure 'show advanced options', 1;
GO
reconfigure;
GO

exec sp_configure 'clr enabled', 1;
exec sp_configure 'clr strict security', 0 
GO

-- clr strict security 
-- 1 (Enabled): заставляет Database Engine игнорировать сведения PERMISSION_SET о сборках 
-- и всегда интерпретировать их как UNSAFE. По умолчанию, начиная с SQL Server 2017.

reconfigure;
GO

-- Для возможности создания сборок с EXTERNAL_ACCESS или UNSAFE
ALTER DATABASE Service SET TRUSTWORTHY ON; 

-- Подключаем dll 

CREATE ASSEMBLY SimpleDemoAssembly
FROM 'C:\Users\пользователь\source\repos\ClassLibrary1\bin\Debug\ClassLibrary1.dll'
WITH PERMISSION_SET = SAFE;  

SELECT * FROM sys.assemblies

CREATE FUNCTION [dbo].SplitStringCLR(@text [nvarchar](max), @delimiter [nchar](1))

RETURNS TABLE (

part nvarchar(max),

ID_ODER int

) WITH EXECUTE AS CALLER

AS 

EXTERNAL NAME [SimpleDemoAssembly].[UserDefinedFunctions.UserDefinedFunctions].SplitString

Go

-- Используем функцию
SELECT dbo.SplitStringCLR('11,22,33,44', ',')

