USE [DB_Testes]
GO

begin
EXECUTE mainprocedures.sp_Main 
	@procedureName = 'dbo.sp_ProcedureSegunda'
end
