--sp quitar descuento 
create or alter procedure sp_QuitarDescuentoProducto
	@ProductoID int
as 
begin 
	set nocount on;
	begin try
		if not exists (select 1 from INVENTARIO where ProductoID = @ProductoID)
		begin
			throw 50001, 'El producto especificado no existe ', 1;
		end 
		
		--verificar si ya no tiene descuento
		if not exists(select 1 from INVENTARIO where ProductoID = @ProductoID and PrecioDescuento is not null)
		begin 
			throw 50002 , 'El producto no tiene ningun descuento activo', 1;
		end 

		begin transaction 
		update INVENTARIO
		set PrecioDescuento = null,
			ModifiedDate = GETDATE()
		where ProductoID = @ProductoID;

		commit transaction;

		select 'Descuento eliminado correctamente' as Mensaje;
	end try
	begin catch 
		if XACT_STATE() <> 0
			rollback transaction;
		DECLARE @Error NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @State INT = ERROR_STATE();
        THROW 50000, @Error, @State;
	end catch
end;