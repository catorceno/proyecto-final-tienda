--preubas sp eliminar descuento 
select * from INVENTARIO

exec sp_QuitarDescuentoProducto
	@ProductoID = 2;
