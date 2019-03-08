USE [DB_Testes]
GO

CREATE OR ALTER PROCEDURE sp_ProcedurePrimeira 
AS
PRINT N'************************************' + CHAR(10) + 
	  N'Primeiro procedimento executado!' + CHAR(10) + 
	  N'************************************'

GO

CREATE OR ALTER PROCEDURE sp_ProcedureSegunda 
AS
PRINT N'************************************' + CHAR(10) + 
	  N'Segundo procedimento executado!' + CHAR(10) + 
	  N'************************************'

GO

CREATE OR ALTER PROCEDURE sp_ProcedureTerceira
AS
DECLARE @errMessage nvarchar(100);

SET @errMessage =  N'************************************' + CHAR(10) + 
	  N'Terceiro procedimento RETORNOU ERRO ERRO!' + CHAR(10) + 
	  N'************************************';

RAISERROR(@errMessage, 16, 1); 

GO

CREATE OR ALTER PROCEDURE sp_ProcedureQuarta 
AS
PRINT N'************************************' + CHAR(10) + 
	  N'Quarto procedimento executado!' + CHAR(10) + 
	  N'************************************'
