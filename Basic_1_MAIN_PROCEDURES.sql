USE [DB_Testes]
GO

IF NOT EXISTS (SELECT TOP 1 * FROM sys.schemas where name = 'mainprocedures')
BEGIN
	EXEC( 'CREATE SCHEMA mainprocedures' );
END
GO


CREATE OR ALTER PROCEDURE mainprocedures.sp_Main
	@procedureName NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @procID INT,
			@logExecID INT

	/*
	Verificar se existe o procedimento na tabela (CadastroProcedures)
	*/
	BEGIN TRY
		EXECUTE mainprocedures.sp_CheckCadastro 
					@procedureName = @procedureName,
					@procID = @procID OUTPUT;
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
		
	/*
	Loga na tabela de Logs (LogProcedures) o in�cio da execu��o do procedimento
	*/
	BEGIN TRY
		EXECUTE mainprocedures.sp_LogExec
					@procID = @procID,
					@initOrEnd = 0,
					@logExecID = @logExecID OUTPUT;		
	END TRY
	BEGIN CATCH
		THROW
	END CATCH

	/*
	Executa o procedimento @procedureExecName
	*/
	PRINT N'Iniciando Procedimento...' + CHAR(10);

	BEGIN TRY
		EXECUTE @procedureName
	END TRY
	BEGIN CATCH
		/*
		Se o Procedimento gera Error, loga-se na tabela ProcLogError e retorna
		*/
		PRINT N'O procedimento (' + @procedureName + ') retornou um erro: ';
		DECLARE @_errMessage NVARCHAR(2000) = CAST(ERROR_NUMBER() AS VARCHAR) + ', ' + ERROR_MESSAGE();
		EXECUTE mainprocedures.sp_LogError 
					@procID = @procID,
					@logExecID = @logExecID,
					@errMessage = @_errMessage;
		
		THROW
	END CATCH

	PRINT CHAR(10) + N'Finalizando...';

	/*
	Loga na tabela de Logs (LogProcedures) o Fim da execu��o do procedimento
	*/
	BEGIN TRY
		EXECUTE mainprocedures.sp_LogExec
					@procID = @procID,
					@initOrEnd = 1,
					@logExecID = @logExecID OUTPUT;		
	END TRY
	BEGIN CATCH
		THROW
	END CATCH

	PRINT CHAR(10) + N'Procedimento (' + @procedureName	+ ') executado com sucesso.';

END
GO	

	
----------------------------------------------------------------------------	

CREATE OR ALTER PROCEDURE mainprocedures.sp_CheckCadastro 
	@procedureName NVARCHAR(100),
	@procID INT OUTPUT
AS
BEGIN

	DECLARE @thisProcName NVARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
		
	SET @procID = (SELECT TOP 1 procID FROM dbo.ProcAvailable AS cp WHERE cp.[name] = @procedureName);
	
	IF @procID IS NOT NULL 
		PRINT '('+@thisProcName+')' + CHAR(10) +
			  N'Procedimento de Nome: (mainprocedures.' + @procedureName + ') encontrado. procID: '
			 + CAST(@procID AS VARCHAR) + '.';
	ELSE
		RAISERROR (N'(%s) N�o existe procedimento com nome: %s.', 16, 1, @thisProcName, @procedureName);
END	
GO

------------------------------------------------------------------------------

/*
--initOrEnd = 0 (In�cio) ; initOrEnd = 1 (Fim)
*/
CREATE OR ALTER PROCEDURE mainprocedures.sp_LogExec 
	@procID INT,
	@initOrEnd INT,
	@logExecID INT OUTPUT
AS
BEGIN
	DECLARE @initOrEndString VARCHAR(10),
			@startDate DATETIME,
			@endDate DATETIME,
			@thisProcName NVARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);

	DECLARE @IdentityOutput table ( ID int );
	
	IF @initOrEnd = 0
		BEGIN
			SET @initOrEndString = 'In�cio';
			SET @startDate = GETDATE();
			SET @endDate = NULL;
		END
	ELSE IF @initOrEnd = 1
		BEGIN
			SET @initOrEndString = 'Fim';
			SET @startDate = NULL;
			SET @endDate = GETDATE();
		END

	INSERT dbo.ProcLogExec (procID, startDate, endDate, execState)
		OUTPUT INSERTED.logExecID
			 INTO @IdentityOutput
				VALUES (@procID, @startDate, @endDate, @initOrEndString);

	SET @logExecID = (select ID from @IdentityOutput);
END
GO


CREATE OR ALTER PROCEDURE mainprocedures.sp_LogError
	@procID INT,
	@logExecID INT,
	@errMessage NVARCHAR(2000)
AS
BEGIN
	DECLARE @initOrEndString VARCHAR(10),
			@thisProcName NVARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID),
			@printMessage NVARCHAR(10);
	
	INSERT INTO dbo.ProcLogError (procID, logExecID, errorMessage, createdAt)
				VALUES (@procID, @logExecID, @errMessage, GETDATE());
END
GO


------------------------------------------------------------------------------
