USE Marketplace
GO

--------------- GESTION DE USUARIOS ---------------
-- 1.
SELECT * FROM USERS 
SELECT * FROM CLIENTES 
EXEC sp_registrarNuevoCliente
	@Correo   = 'sp@gmail.com',
	@Password = 'sp123',
	@Nombre   = 'sp_name',
	@Apellido = 'sp_lastname',
	@Telefono = 11111111;

-- 2.
SELECT * FROM USERS 
SELECT * FROM TIENDAS
EXEC sp_registrarNuevaTienda
	@Correo   = 'spTienda@gmail.com',
	@Password = 'spTienda123',
	@Nombre   = 'spTiendaName',
	@NombreJuridico = 'spTiendaLastName',
	@NIT      = 444444444,
	@Telefono = 44444444,
	@CategoriaID = 1;

-- 3.
SELECT * FROM USERS
EXEC sp_inicioSesion
	@Correo   = 'spTienda@gmail.com',
	@Password = 'spTienda123';

--------------- GESTION DE INVENTARIO ---------------
-- 1. ... falta implementar ...
EXEC sp_aplicarDescuentoAProducto
    @TiendaID    = ,
    @DescuentoID = ,
    @ProductoID  = ;

--------------- GESTI�N DE VENTAS ---------------
-- 1.
SELECT * FROM COMPRAS 
SELECT * FROM VENTAS 
SELECT * FROM DETALLE_VENTA -- falta implementar aquí
EXEC sp_procesoVenta 
  @ClienteID      = 1, 
  @DireccionID    = 1, 
  @Subtotal       = 100.00, 
  @ServiceFee     = 5.00, 
  @Total          = 105.00, 
  @ProductoID     = 2, 
  @Cantidad       = 1, 
  @PrecioUnitario = 100.00;



--
CREATE PROCEDURE sp_
@
AS
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
		IF ()
		BEGIN
			THROW 50005, '', 1;
		END
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;	
	END CATCH
END;
