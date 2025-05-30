USE Tienda
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
-- 1.
SELECT * FROM INVENTARIO
EXEC sp_aplicarDescuentoAProducto
    @TiendaID    = 1,
    @DescuentoID = 1,
    @ProductoID  = 3;

--------------- GESTION DE VENTAS ---------------
-- 1.
SELECT * FROM CLIENTES
SELECT * FROM DIRECCIONES   WHERE ClienteID = 1
SELECT * FROM DATOS_FACTURA WHERE ClienteID = 1
SELECT * FROM TARJETAS      WHERE ClienteID = 1

SELECT * FROM INVENTARIO
SELECT * FROM COMPRAS 
SELECT * FROM VENTAS 
SELECT * FROM DETALLE_VENTA

SELECT * FROM PRODUCTOS
EXEC sp_procesoVenta 
	@ClienteID		= 1,
	@DireccionID	= 1,
	@FacturaID		= 1,
	@MetodoPago		= 'Efectivo',
	@TarjetaID		= NULL,
	@ProductoID		= 1,
	@Cantidad       = 1,
	@PrecioUnitario = 50,
	@Subtotal		= 50,
	@ServiceFee		= 5,
	@Total			= 55;
SELECT * FROM INVENTARIO
SELECT * FROM PRODUCTOS



DECLARE @ItemsCarrito dbo.TablaItems;
INSERT INTO @ItemsCarrito (ProductoID, Cantidad, PrecioUnitario) VALUES
	(, , ),
	(, , ),
	(, , );
EXEC usp_procesoVenta
	@ClienteID		= 1,
	@DireccionID	= 1,
	@FacturaID		= 1,
	@MetodoPago		= 'Efectivo',
	@TarjetaID		= NULL,
	@Items          = @ItemsCarrito,
	@Subtotal		= 50,
	@ServiceFee		= 5,
	@Total			= 55;


--------------- GESTION DE PAGOS ---------------
-- 1.
SELECT * FROM DIRECCIONES 
EXEC sp_registrarDireccion
@ClienteID = ,
@Barrito ,
@Calle ,
@Numero 

-- 2.
SELECT * FROM TARJETAS 
EXEC sp_registrarTarjeta
@ClienteID =,
@Red,
@NombreTitular,
@Numero,
@CVC,
@ExpDate

-- 3.
SELECT * FROM DATOS_FACTURA 
EXEC sp_registrarDatosFactura
@ClienteID = ,
@RazonSocial ,
@NitCi 


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
