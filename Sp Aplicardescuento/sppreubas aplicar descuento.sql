--pruebas de nuestro sp agragar descuento 
select * from INVENTARIO
select * from PRODUCTOS


	exec sp_AplicarDescuentoProducto
		@ProductoID = 10,
		@PorcentajeDescuento = 10; --PUEDES INTRODUCRI 0.10 O 10 CUALQUIERA DE LOS DSO ES VALIDO 