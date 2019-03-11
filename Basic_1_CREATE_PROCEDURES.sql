USE [DB_Testes]
GO

CREATE OR ALTER PROCEDURE sp_Procedure_1
AS
PRINT N'************************************' + CHAR(10) + 
	  N'Primeiro procedimento executado!' + CHAR(10) + 
	  N'************************************'

GO

CREATE OR ALTER PROCEDURE sp_Procedure_2
AS
DECLARE @errMessage nvarchar(100);

SET @errMessage =  N'************************************' + CHAR(10) + 
	  N'Segundo procedimento RETORNOU ERRO ERRO!' + CHAR(10) + 
	  N'************************************';

RAISERROR(@errMessage, 16, 1); 

GO

CREATE OR ALTER PROCEDURE sp_Procedure_3
AS
	DECLARE @i INT = 1;

	WHILE (@i <= 5)
	 BEGIN
	  WAITFOR DELAY '00:00:01';
	  
	 SET  @i = @i + 1;
	END 

GO

CREATE OR ALTER PROCEDURE sp_Procedure_4
AS
	DECLARE @i INT = 1;

	WHILE (@i <= 15)
	 BEGIN
	  WAITFOR DELAY '00:00:01';
	  
	 SET  @i = @i + 1;
	END 

GO
CREATE OR ALTER PROCEDURE sp_Procedure_5
AS
	DECLARE @i INT = 1;

	WHILE (@i <= 35)
	 BEGIN
	  WAITFOR DELAY '00:00:01';
	  
	 SET  @i = @i + 1;
	END 

GO
CREATE OR ALTER PROCEDURE sp_Procedure_6
AS
	DECLARE @i INT = 1;

	WHILE (@i <= 60)
	 BEGIN
	  WAITFOR DELAY '00:00:01';
	  
	 SET  @i = @i + 1;
	END 

GO
CREATE OR ALTER PROCEDURE sp_Procedure_7
AS
	DECLARE @i INT = 1;

	WHILE (@i <= 100)
	 BEGIN
	  WAITFOR DELAY '00:00:01';
	  
	 SET  @i = @i + 1;
END 

GO
CREATE OR ALTER PROCEDURE sp_Procedure_8
AS
	DECLARE @i INT = 1;

	WHILE (@i <= 100)
	 BEGIN
	  WAITFOR DELAY '00:00:01';
	  
	 SET  @i = @i + 1;
END 