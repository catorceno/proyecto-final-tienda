USE Marketplace
GO

SELECT * FROM CATEGORIAS
--------------- GESTION DE USUARIOS ---------------
SELECT * FROM USERS
SELECT * FROM CLIENTES 
SELECT * FROM TIENDAS 
-- trigger o sp: REGISTRO NUEVO USUARIO, INICIO SESIÓN USUARIO EXISTENTE
INSERT INTO USERS(Correo, Password, Tipo)
VALUES 
	('cliente1@gmail.com', '123cliente1', 'Cliente'), -- 1
	('cliente2@gmail.com', '123cliente2', 'Cliente'), -- 2
	('tienda1@gmail.com', '123tienda1', 'Tienda'), -- 3
	('tienda2@gmail.com', '123tienda2', 'Tienda'), -- 4
	('tienda3@gmail.com', '123tienda3', 'Tienda'); -- 5
INSERT INTO CLIENTES(UserID, Nombre, Apellido, Telefono)
VALUES 
	(1, 'Cliente1', 'Cliente1Apellido', 11111111),
	(2, 'Cliente2', 'Cliente2Apellido', 22222222);
INSERT INTO TIENDAS(UserID, CategoriaID, Nombre, NombreJuridico, NIT, Telefono)
VALUES 
	(3, 1, 'tiendaTec1', 'tiendaTec1 SA', 111111111, 11111111), -- 1
	(4, 1, 'tiendaTec2', 'tiendaTec2 SA', 222222222, 22222222), -- 2
	(5, 1, 'tiendaTec3', 'tiendaTec3 SA', 333333333, 33333333); -- 3

SELECT * FROM SUBCATEGORIAS 
--------------- GESTIÓN DE INVENTARIO ---------------
SELECT * FROM DESCUENTOS 
SELECT * FROM INVENTARIO 
SELECT * FROM PRODUCTOS 
-- trigger o sp: 
INSERT INTO DESCUENTOS(TiendaID, Nombre, Porcentaje, StartDate)
VALUES 
	(1, 'Dia de la Madre', 50, '2025-05-27');
INSERT INTO INVENTARIO(TiendaID, SubcategoriaID, Nombre, Precio)
VALUES 
	(1, 1, 'IPhone1', 100), -- celulares
	(1, 1, 'IPhone2', 100),
	(1, 1, 'IPhone3', 100),
	(2, 3, 'Laptop1', 200), -- laptops
	(2, 3, 'Laptop2', 200),
	(3, 9, 'Televisor1', 300); -- televisores
INSERT INTO PRODUCTOS(Codigo, ProductoID) -- TRIGGER1: trg_calcularStockInsertItem
VALUES 
	(111, 1), -- iphone1
	(112, 1),
	(113, 1),
	(114, 1),
	(115, 1),
	(116, 1),
	(121, 2), -- iphone2
	(122, 2),
	(123, 2),
	(124, 2),
	(125, 2),
	(131, 3), -- iphone3
	(132, 3),
	(133, 3),
	(134, 3),
	(135, 3),
	(211, 4), -- laptop1
	(212, 4),
	(213, 4),
	(214, 4),
	(215, 4),
	(221, 5), -- laptop2
	(222, 5),
	(223, 5),
	(224, 5),
	(225, 5),
	(311, 6), -- televisor1
	(312, 6),
	(313, 6),
	(314, 6),
	(315, 6);

-- TRIGGER2 : trg_calcularPrecioDescuento
UPDATE INVENTARIO 
SET DescuentoID = 1
WHERE ProductoID = 1
SELECT * FROM INVENTARIO

SELECT * FROM CLIENTES
--------------- GESTIÓN DE VENTAS ---------------
SELECT * FROM DIRECCIONES 
SELECT * FROM CLIENTE_DIRECCION 
INSERT INTO DIRECCIONES(Barrio, Calle, Numero)
VALUES 
	('barrio1', 'calle1', 11),
	('barrio2', 'calle2', 12),
	('barrio3', 'calle3', 13),
	('barrio4', 'calle4', 21),
	('barrio5', 'calle5', 22);
INSERT INTO CLIENTE_DIRECCION(ClienteID, DireccionID)
VALUES 
	(1, 1),
	(1, 2),
	(1, 3),
	(2, 4),
	(2, 5);

SELECT * FROM COMPRAS 
SELECT * FROM VENTAS 
SELECT * FROM DETALLE_VENTA
SELECT * FROM PRODUCTOS
EXEC sp_procesoVenta 
  @ClienteID      = 1, 
  @DireccionID    = 1, 
  @Subtotal       = 100.00, 
  @ServiceFee     = 5.00, 
  @Total          = 105.00, 
  @ProductoID     = 2, 
  @Cantidad       = 1, 
  @PrecioUnitario = 100.00;
INSERT INTO DETALLE_VENTA(VentaID, ItemID)VALUES (2, 8); -- ya no sera necesario, despues de terminar de implementar el sp

--------------- GESTIÓN DE PAGOS ---------------
SELECT * FROM TARJETAS 
SELECT * FROM CLIENTE_TARJETA 
SELECT * FROM DATOS_FACTURA 
SELECT * FROM CLIENTE_FACTURA 
-- IMPLEMENTAR sp : registro de una Tarjeta
-- IMPLEMENTAR sp : registro de datos para facturas

SELECT * FROM PAGOS 