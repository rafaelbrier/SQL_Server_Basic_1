USE [DB_Testes]
GO

begin
EXECUTE mainprocedures.sp_Main 
	@procedureName = 'dbo.sp_procedure_4'
end
