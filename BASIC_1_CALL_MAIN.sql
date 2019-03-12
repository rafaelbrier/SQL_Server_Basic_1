USE [DB_Testes]
GO

begin
EXECUTE mainprocedures.sp_Main 
	@procedureName = 'dbo.sp_procedure_2'
end
