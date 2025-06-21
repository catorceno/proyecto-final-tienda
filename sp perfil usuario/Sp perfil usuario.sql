
use Marcket_Actualizado
USE Marcket_Actualizado;
GO

SELECT name AS Nombre_SP
FROM sys.procedures
ORDER BY name;
--sp ejecutado 
create or alter procedure sp_PerfilUsuario
	@Correo nvarchar(200)
as 
begin 
	set nocount on;
	begin try
		if not exists(select 1 from USERS where Correo = @Correo)
		begin 
			throw 50001, 'El usuario no existe', 1; 
		end 

		select Correo, Tipo, Estado from USERS
		where Correo = @Correo;
	end try 
	begin catch 
		if XACT_STATE() <> 0
			rollback transaction;
			declare @ERRORMESSAGE NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @ERRORSTATE INT = ERROR_STATE();
			THROW 50000, @ERRORMESSAGE , @ERRORSTATE;
	end catch
end;
go