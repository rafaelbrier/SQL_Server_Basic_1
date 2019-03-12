USE [DB_Testes]
GO

IF NOT EXISTS (SELECT TOP 1 * FROM sys.schemas where name = 'mainprocedures')
BEGIN
	EXEC( 'CREATE SCHEMA mainprocedures' );
END
GO


CREATE OR ALTER PROCEDURE mainprocedures.sp_Main
	@procedureName NVARCHAR(100),
	@param1 sql_variant = NULL,
	@param2 sql_variant = NULL,
	@param3 sql_variant = NULL,
	@param4 sql_variant = NULL,
	@param5 sql_variant = NULL
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @procID INT,
			@logExecStartPointID INT = NULL,
			@logExecID INT = NULL,
			@elapsedTime INT = NULL,
			@_errCode INT = NULL,
			@_errMessage NVARCHAR(2000) = NULL;

	/*
	Verificar se existe o procedimento na tabela (CadastroProcedures)
	*/
	BEGIN TRY
		EXECUTE mainprocedures.sp_CheckCadastro 
					@procedureName = @procedureName,
					@procID = @procID OUTPUT;
	END TRY
	BEGIN CATCH
		--Se o Procedimento gera Error, loga-se na tabela ProcLogError e retorna	
		SET @_errCode = ERROR_NUMBER();
		SET @_errMessage = ERROR_MESSAGE();	
		EXECUTE mainprocedures.sp_LogError 
					@procID = @procID,
					@logExecID = @logExecID,
					@errCode =  @_errCode,
					@errMessage = @_errMessage;
		THROW
	END CATCH
	/*
	----------------------------------------------------------------------
	*/

		
	/*
	Loga na tabela de Logs (LogProcedures) o início da execução do procedimento
	*/
	BEGIN TRY
		EXECUTE mainprocedures.sp_LogExec
					@procID = @procID,
					@startPointID = NULL,
					@executionTime = @elapsedTime,
					@createOrUpdate = 0,
					@execStatus = 1, -- 1 = Em Execução
					@logExecID = @logExecID OUTPUT;		
	END TRY
	BEGIN CATCH
		--Se o Procedimento gera Error, loga-se na tabela ProcLogError e retorna
		SET @_errCode = ERROR_NUMBER();
		SET @_errMessage = ERROR_MESSAGE();
		EXECUTE mainprocedures.sp_LogError 
					@procID = @procID,
					@logExecID = @logExecID,
					@errCode =  @_errCode,
					@errMessage = @_errMessage;
		THROW
	END CATCH

	SET @logExecStartPointID = @logExecID;
	/*
	----------------------------------------------------------------------
	*/

	PRINT N'Iniciando Procedimento...' + CHAR(10);

	/*
	Executa o procedimento @procedureExecName
	*/
	DECLARE @tstart DATETIME;
	DECLARE @tend DATETIME;
	BEGIN TRY
		SET @tstart = GETDATE();
		EXECUTE @procedureName
		SET @tend = GETDATE();
		
		SET @elapsedTime = DATEDIFF(millisecond,@tstart,@tend);
		
		DECLARE @avgTime INT;
		
		/* SALVA A MÉDIA DOS TEMPOS DE EXECUÇÃO*/
		BEGIN TRY
			SET @avgTime =  (SELECT TOP 10 AVG(executionTime) as avgExecTime FROM dbo.ProcLogExec AS ple
							WHERE (ple.executionTime IS NOT NULL AND ple.procId = @procID))

			UPDATE [dbo].[ProcAvailable]
				   SET [estimatedRunTime] = @avgTime,
					   [lastExecution] = GETDATE()
                   WHERE procId = @procID;

		END TRY
		BEGIN CATCH
			SET @_errCode = ERROR_NUMBER();
			SET @_errMessage = ERROR_MESSAGE();
			EXECUTE mainprocedures.sp_LogError 
						@procID = @procID,
						@logExecID = @logExecID,
						@errCode =  @_errCode,
						@errMessage = @_errMessage;
		
			THROW
		END CATCH

		PRINT 'Tempo de execucao: ' + CAST(@elapsedTime as VARCHAR) + 'ms';


	END TRY
	BEGIN CATCH
		--Se o Procedimento gera Error, loga-se na tabela ProcLogExec a finalização com ERRO
		EXECUTE mainprocedures.sp_LogExec
					@procID = @procID,
					@startPointID = @logExecStartPointID,
					@executionTime = @elapsedTime,
					@createOrUpdate = 1,
					@execStatus = -1, --execStatus 9 = error
					@logExecID = @logExecID OUTPUT;		
		
		--Loga-se também na tabela ProcLogError e retorna
		PRINT N'O procedimento (' + @procedureName + ') retornou um erro: ';
		SET @_errCode = ERROR_NUMBER();
		SET @_errMessage = ERROR_MESSAGE();
		EXECUTE mainprocedures.sp_LogError 
					@procID = @procID,
					@logExecID = @logExecID,
					@errCode =  @_errCode,
					@errMessage = @_errMessage;
		
		THROW
	END CATCH
	/*
	----------------------------------------------------------------------
	*/

	PRINT CHAR(10) + N'Finalizando...';

	/*
	Loga na tabela de Logs (LogProcedures) o Fim da execução do procedimento
	*/
	BEGIN TRY
		EXECUTE mainprocedures.sp_LogExec
					@procID = @procID,
					@startPointID = @logExecStartPointID,
					@executionTime = @elapsedTime,
					@createOrUpdate = 1,
					@execStatus = 0,
					@logExecID = @logExecID OUTPUT;		
	END TRY
	BEGIN CATCH
		--Se o Procedimento gera Error, loga-se na tabela ProcLogError e retorna
		SET @_errCode = ERROR_NUMBER();
		SET @_errMessage = ERROR_MESSAGE();
		EXECUTE mainprocedures.sp_LogError 
					@procID = @procID,
					@logExecID = @logExecID,
					@errCode =  @_errCode,
					@errMessage = @_errMessage;
		THROW
	END CATCH
	/*
	----------------------------------------------------------------------
	*/

	PRINT CHAR(10) + N'Procedimento (' + @procedureName	+ ') executado com sucesso.';

END
GO	

	
/*
Procedimento que verifica no Banco se o mesmo está cadastro no sistema (Tabela - dbo.ProcAvailable)
*/
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
		RAISERROR (N'(%s) Não existe procedimento com nome: %s.', 16, 1, @thisProcName, @procedureName);
END	
GO
/*
----------------------------------------------------------------------
*/


/*
Procedimento que loga no banco o início e fim das execuções dos procedimentos (Tabela - dbo.ProcLogExec)

--@createOrUpdate = 0 (create) ; @createOrUpdate = 1 (update)
--@execStatus = 0 (S - Sucesso) ; @execStatus = -1 (E - Error); @execStatus = 1 (R - Em Execução); @execStatus = 2 (F - Finalizado com Erro);
 @execStatus = 3 (T - Passou do tempo médio)
*/
CREATE OR ALTER PROCEDURE mainprocedures.sp_LogExec 
	@procID INT,
	@startPointID INT,
	@executionTime INT,
	@createOrUpdate BIT,
	@execStatus INT,
	@logExecID INT OUTPUT
AS
BEGIN
	DECLARE @startDate DATETIME,
			@endDate DATETIME,
			@execChar CHAR(1),
			@thisProcName NVARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);

	DECLARE @IdentityOutput table ( ID int );
	
	IF @createOrUpdate = 0
		BEGIN
			SET @startDate = GETDATE();
			SET @endDate = NULL;
		END
	ELSE IF @createOrUpdate = 1
		BEGIN
			SET @endDate = GETDATE();
		END

	IF @execStatus = 0
		SET @execChar = 'S';
	ELSE IF @execStatus = 1
		SET @execChar = 'R';
	ELSE IF @execStatus = 2
		SET @execChar = 'F';
	ELSE IF @execStatus = 3
		SET @execChar = 'T';
	ELSE IF @execStatus = -1
		SET @execChar = 'E';

	IF @createOrUpdate = 0
		BEGIN
			SET @startDate = GETDATE();
			SET @endDate = NULL;
			INSERT dbo.ProcLogExec (procID, startDate, endDate, execStatus)
				OUTPUT INSERTED.logExecID
						INTO @IdentityOutput
						VALUES (@procID, @startDate, @endDate, @execChar);
			IF @@ERROR <> 0
				RAISERROR('Erro iniciar o log do procedimento.', 16, 1);

			SET @logExecID = (select ID from @IdentityOutput);
		END
	ELSE IF @createOrUpdate = 1
		BEGIN
			SET @endDate = GETDATE();
			UPDATE [dbo].[ProcLogExec]
			   SET [endDate] = @endDate,
				   [execStatus] = @execChar,
				   [executionTime] = @executionTime
				 				  
			 WHERE [logExecId] = @startPointID
			 IF @@ERROR <> 0
				RAISERROR('Erro ao atualizar o log do procedimento.', 16, 1);
		END
	
END
GO
/*
----------------------------------------------------------------------
*/



/*
Procedimento que loga no banco os erros ocorridos durante a execução da função Main (Tabela - dbo.ProcLogError)
*/
CREATE OR ALTER PROCEDURE mainprocedures.sp_LogError
	@procID INT,
	@logExecID INT,
	@errCode INT,
	@errMessage NVARCHAR(2000)
AS
BEGIN
	DECLARE @initOrEndString VARCHAR(10),
			@thisProcName NVARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID),
			@printMessage NVARCHAR(10);
	
	INSERT INTO dbo.ProcLogError (procID, logExecID, errorCode, errorMessage, createdAt)
				VALUES (@procID, @logExecID, @errCode, @errMessage, GETDATE());

	IF @@ERROR <> 0
		RAISERROR('Erro ao logar o erro do procedimento.', 16, 1);
END
GO
/*
----------------------------------------------------------------------
*/


------------------------------------------------------------------------------
