USE [DB_Testes]
GO

begin
EXECUTE mainprocedures.sp_Main 
	@procedureName = 'dbo.sp_procedure_8'
end

begin
EXECUTE mainprocedures.sp_Main 
	@procedureName = 'dbo.sp_procedure_7'
end

begin
EXECUTE mainprocedures.sp_Main 
	@procedureName = 'dbo.sp_procedure_6'
end

begin
EXECUTE mainprocedures.sp_Main 
	@procedureName = 'dbo.sp_procedure_6'
end
