USE Tienda
GO

--------------- GESTION DE USUARIOS ---------------
SELECT * FROM USERS
SELECT * FROM CLIENTES 
SELECT * FROM TIENDAS 
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

--------------- GESTIÓN DE INVENTARIO ---------------
SELECT * FROM DESCUENTOS 
SELECT * FROM INVENTARIO 
SELECT * FROM PRODUCTOS 
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
INSERT INTO PRODUCTOS(Codigo, ProductoID)
VALUES 
	(111, 1), -- iphone1
	(112, 1),
	(113, 1),
	(114, 1),
	(115, 1),
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

--------------- GESTI�N DE VENTAS ---------------
SELECT * FROM DIRECCIONES 
INSERT INTO DIRECCIONES(ClienteID, Barrio, Calle, Numero)
VALUES 
	(1, 'barrio1', 'calle1', 11),
	(1, 'barrio2', 'calle2', 12),
	(1, 'barrio3', 'calle3', 13),
	(2, 'barrio4', 'calle4', 21),
	(2, 'barrio5', 'calle5', 22);

SELECT * FROM COMPRAS 
SELECT * FROM VENTAS 
SELECT * FROM DETALLE_VENTA
select * from PRODUCTOS
EXEC sp_procesoVenta 
  @ClienteID      = 1, 
  @DireccionID    = 1, 
  @Subtotal       = 100.00, 
  @ServiceFee     = 5.00, 
  @Total          = 105.00, 
  @ProductoID     = 2, 
  @Cantidad       = 1, 
  @PrecioUnitario = 100.00;

--------------- GESTIÓN DE PAGOS ---------------
SELECT * FROM TARJETAS 
SELECT * FROM DATOS_FACTURA 
SELECT * FROM PAGOS 
INSERT INTO TARJETAS(ClienteID, Red, NombreTitular, Numero, ExpDate, CVC)
VALUES 
	(1, 'Visa', 'TarjetaCliente1', 1234123412341234, '2025-06-10', 123),
	(1, 'MasterCard', 'Tarjeta2Cliente1', 1234123412341235, '2025-06-10', 124),
	(2, 'Visa', 'TarjetaCliente2', 1234123412341234, '2025-06-10', 123);
INSERT INTO DATOS_FACTURA(ClienteID, RazonSocial, NitCi)
VALUES 
	(1, 'Cliente1Factura', 1111111),
	(2, 'Cliente2Factura', 2222222);
INSERT INTO PAGOS(CompraID, FacturaID, TarjetaID, MetodoPago, Monto)
VALUES 
	(1, 1, 1, 'Tarjeta', 305),
	(2, 2, NULL, 'Efectivo', 205);