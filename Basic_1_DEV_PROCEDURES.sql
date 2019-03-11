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
	INSERT INTO dbo.ProcAvailable (procId, name, schedulePeriod, scheduleTime, createdAt)
	VALUES('', 'dbo.sp_procedure_1', 'diário', '10:00:00', GETDATE());

	INSERT INTO dbo.ProcAvailable (procId, name, schedulePeriod, scheduleTime, createdAt)
	VALUES('', 'dbo.sp_procedure_2', 'diário', '10:00:00', GETDATE());

	INSERT INTO dbo.ProcAvailable (procId, name, schedulePeriod, scheduleTime, createdAt)
	VALUES('', 'dbo.sp_procedure_3', 'diário', '10:00:00', GETDATE());

	INSERT INTO dbo.ProcAvailable (procId, name, schedulePeriod, scheduleTime, createdAt)
	VALUES('', 'dbo.sp_procedure_4', 'diário', '10:00:00', GETDATE());

	INSERT INTO dbo.ProcAvailable (procId, name, schedulePeriod, scheduleTime, createdAt)
	VALUES('', 'dbo.sp_procedure_5', 'diário', '10:00:00', GETDATE());

	INSERT INTO dbo.ProcAvailable (procId, name, schedulePeriod, scheduleTime, createdAt)
	VALUES('', 'dbo.sp_procedure_6', 'diário', '10:00:00', GETDATE());

	INSERT INTO dbo.ProcAvailable (procId, name, schedulePeriod, scheduleTime, createdAt)
	VALUES('', 'dbo.sp_procedure_7', 'diário', '10:00:00', GETDATE());

	INSERT INTO dbo.ProcAvailable (procId, name, schedulePeriod, scheduleTime, createdAt)
	VALUES('', 'dbo.sp_procedure_8', 'diário', '10:00:00', GETDATE());

	INSERT INTO dbo.ProcAvailable (procId, name, schedulePeriod, scheduleTime, createdAt)
	VALUES('', 'dbo.sp_procedure_9', 'diário', '10:00:00', GETDATE());

	INSERT INTO dbo.ProcAvailable (procId, name, schedulePeriod, scheduleTime, createdAt)
	VALUES('', 'dbo.sp_procedure_10', 'diário', '10:00:00', GETDATE());
				
GO	

EXECUTE devprocedures.sp_PopulateTables;

GO

