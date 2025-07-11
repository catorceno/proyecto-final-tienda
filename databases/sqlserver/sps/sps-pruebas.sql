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
    @DescuentoID = 1,
    @ProductoID  = 3;
--------------- CRUD INVENTARIO ---------------
-- 2.
EXEC sp_registrarProducto
@TiendaID       ,
@SubcategoriaID ,
@Nombre         ,
@Precio         ,
@Descripcion    

-- 3.
EXEC sp_editarProducto
@ProductoID     INT,
@SubcategoriaID INT,
@Nombre         NVARCHAR(50),
@Precio         DECIMAL(20,2),
@Descripcion    NVARCHAR(200),
@DescuentoID    INT

-- 4.
EXEC sp_eliminarProducto
@TiendaID   = 1,
@ProductoID = 1

-- 5.
EXEC sp_verInventario @TiendaID = 2;

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
SELECT * FROM PAGOS 

SELECT * FROM PRODUCTOS
EXEC sp_procesoVenta 
	@ClienteID		= 1,
	@DireccionID	= 1,
	@FacturaID		= 1,
	@MetodoPago		= 'Efectivo',
	@TarjetaID		= NULL,
	@ProductoID		= 8,
	@Cantidad       = 1,
	@PrecioUnitario = 100,
	@Subtotal		= 100,
	@ServiceFee		= 5,
	@Total			= 105;
SELECT * FROM INVENTARIO
SELECT * FROM PRODUCTOS

-- 2.
SELECT * FROM DIRECCIONES 
EXEC sp_registrarDireccion
@ClienteID = 1,
@Barrio    = 'barrio sp',
@Calle     = 'calle sp',
@Numero    = 123;

--------------- GESTION DE PAGOS ---------------
-- 1.
SELECT * FROM TARJETAS 
EXEC sp_registrarTarjeta
@ClienteID     = 1,
@Red           = 'Visa',
@NombreTitular = 'Tarjeta3Cliente1-sp',
@Numero        = 1234123412341236,
@CVC           = 125,
@ExpDate       = '2025-08-01';

--------------- CRUD DATOS FACTURA ---------------
-- 1.
SELECT * FROM DATOS_FACTURA 
EXEC sp_registrarDatosFactura
@ClienteID   = 1,
@RazonSocial = 'Cliente1Factura2-sp',
@NitCi       = 3333333;

-- 2.
EXEC sp_editarDatosFactura
@FacturaID   = 2,
@RazonSocial = 'Cliente1Factura2-sp-editar',
@NitCi       = 3333333;

--------------- OTROS ---------------
-- 1.
EXEC sp_verVentas  @TiendaID = 1;