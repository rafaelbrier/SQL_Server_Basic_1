/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [logExecId]
      ,[endDate]
      ,[execStatus]
      ,[executionTime]
      ,[startDate]
      ,[procId]
  FROM [DB_Testes].[dbo].[ProcLogExec]

USE [DB_Testes]
GO

  (SELECT TOP 10 AVG(executionTime) as avgExecTime FROM dbo.ProcLogExec AS ple
							WHERE (ple.executionTime IS NOT NULL AND ple.procId = 3))


select * 
from dbo.ProcLogExec AS ple 
order by (case when execStatus='R' then -1 end) desc, startDate desc

SELECT *
FROM dbo.ProcLogExec AS ple LEFT JOIN dbo.ProcAvailable AS pa  ON ple.procId = pa.procId
WHERE ((pa.[name] LIKE CONCAT('%', '13/9', '%') OR '12/03/2019' IS NULL)
	  OR (CAST(ple.startDate as DATE) = Convert(varchar(30),'12/03/2019',103) OR '12/03/2019' IS NULL))
order by (case when execStatus='R' then -1 end) desc, startDate DESC

SELECT *
FROM dbo.ProcLogExec AS ple LEFT JOIN dbo.ProcAvailable AS pa  ON ple.procId = pa.procId
WHERE ((pa.[name] LIKE CONCAT('%', '13/9', '%') OR '12/03/2019' IS NULL)
	  OR (CONVERT(VARCHAR(30), ple.startDate, 103) LIKE CONCAT('%', '13/', '%')  OR '12/03/2019' IS NULL))
order by (case when execStatus='R' then -1 end) desc, startDate desc


DECLARE @A DATETIME;
DECLARE @B VARCHAR(30);
SET @A = GETDATE();
SET @B = CONVERT(VARCHAR(30), @A, 103)
PRINT @B