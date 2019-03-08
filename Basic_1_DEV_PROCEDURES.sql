USE [DB_Testes]
GO

IF NOT EXISTS (SELECT TOP 1 * FROM sys.schemas where name = 'devprocedures')
BEGIN
EXEC( 'CREATE SCHEMA devprocedures' );
END
GO

CREATE OR ALTER PROCEDURE devprocedures.sp_PopulateTables
AS
	--Table CadastroProcedures
	INSERT INTO dbo.ProcAvailable (name, schedulePeriod, scheduleTime, createdAt)
	VALUES('dbo.sp_ProcedurePrimeira', 'diário', '10:00:00', GETDATE());
	
	INSERT INTO dbo.ProcAvailable (name, schedulePeriod, scheduleTime, createdAt)
	VALUES('dbo.sp_ProcedureSegunda', 'mensal', '15:00:00', GETDATE());
	
	INSERT INTO dbo.ProcAvailable (name, schedulePeriod, scheduleTime, createdAt)
	VALUES('dbo.sp_ProcedureTerceira', 'semanal', '22:00:00', GETDATE());
	
	INSERT INTO dbo.ProcAvailable (name, schedulePeriod, scheduleTime, createdAt)
	VALUES('dbo.sp_ProcedureQuarta', 'anual','09:00:00', GETDATE());
	
	INSERT INTO dbo.ProcAvailable (name, schedulePeriod, scheduleTime, createdAt)
	VALUES('dbo.sp_ProcedureQuinta', 'diário', '06:30:00', GETDATE());
		
GO	

EXECUTE devprocedures.sp_PopulateTables;