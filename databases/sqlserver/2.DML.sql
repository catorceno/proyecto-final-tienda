USE Tienda
GO

-- Registros Fijos
-- 1.Categorias
SELECT * FROM CATEGORIAS
INSERT INTO CATEGORIAS(Nombre)
VALUES
	('Tecnología'),
	('Ropa y accesorios'),
	('Hogar y Jardín'),
	('Electrodomésticos'),
	('Cuidado Personal y Belleza'),
	('Entretenimiento'),
	('Mascotas'),
	('Otro');
GO

-- 2.Subcategorias
SELECT * FROM SUBCATEGORIAS
INSERT INTO SUBCATEGORIAS(CategoriaID, Nombre)
VALUES
	(1, 'Celulares'),
	(1, 'Accesorios para celulares'),
	(1, 'Laptops'),
	(1, 'PC de Escritorio'),
	(1, 'Accesorios de computo'),
	(1, 'Tablets'),
	(1, 'Smartwatches'),
	(1, 'Impresoras'),
	(1, 'Televisores'),
	(1, 'Consolas'),
	(1, 'Proyectores de Video'),
	(1, 'Parlantes'),
	(1, 'Audio Personal'),
	(1, 'Otros'),

	(2, 'Bolsos y Equipaje'),
	(2, 'Joyas'),
	(2, 'Accesorios'),
	(2, 'Calzados'),
	(2, 'Trajes de Baño'),
	(2, 'Ropa para Mujer'),
	(2, 'Ropa para Hombre'),
	(2, 'Ropa para Niños'),
	(2, 'Ropa deportiva'),
	(2, 'Otros'),
	
	(3, 'Muebles'),
	(3, 'Decoración'),
	(3, 'Jardinería'),
	(3, 'Limpieza'),
	(3, 'Herramientas'),
	(3, 'Cama y colchones'),
	(3, 'Otros'),

	(4, 'Climatización'),
	(4, 'Cocinas y Encimeras'),
	(4, 'Refrigeración'),
	(4, 'Hornos y Microondas'),
	(4, 'Lavadoras y Secadoras'),
	(4, 'Extractores'),
	(4, 'Parrillas Eléctricas'),
	(4, 'Electrodomésticos Pequeños'),
	(4, 'Otros'),

	(5, 'Cuidado Corporal'),
	(5, 'Cuidado de la Piel'),
	(5, 'Maquillaje'),
	(5, 'Planchas'),
	(5, 'Cuidado Capilar'),
	(5, 'Peines y Cepillos'),
	(5, 'Secadoras de cabello'),
	(5, 'Rasuradoras y Cortadoras de cabello'),
	(5, 'Otros'),

	(6, 'Juguetes'),
	(6, 'Juegos'),
	(6, 'Videojuegos'),
	(6, 'Películas'),
	(6, 'Libros'),
	(6, 'Artes y manualidades'),
	(6, 'Otros'),

	(7, 'Juguetes'),
	(7, 'Alimento'),
	(7, 'Higiene'),
	(7, 'Ropa'),
	(7, 'Otros artículos'),

	(8, 'Suministros de oficina'),
	(8, 'Decoración de eventos'),
	(8, 'Equipamiento Médico'),
	(8, 'Otros');
GO

-- Registros Dinámicos - Poblando Tablas
-- 3.Users
SELECT * FROM USERS
INSERT INTO USERS(Correo, Password, Tipo)
VALUES 
	('cliente@gmail.com', 'Manchas14', 'Cliente'),
	('tienda@gmail.com', 'Manchas1415', 'Tienda');

-- 4.Clientes
SELECT * FROM CLIENTES
INSERT INTO CLIENTES(UserID, Nombre, Apellido, Telefono)
VALUES
	(1, 'Camila', 'Catorceno', 76468337);

-- 5.Tiendas
SELECT * FROM TIENDAS
INSERT INTO TIENDAS(UserID, CategoriaID, Nombre, NombreJuridico, NIT, Telefono)
VALUES
	(2, 7, 'PetShop', 'PetShop S.A.', 123456789, 76400014);

-- 6.Tarjetas
SELECT * FROM TARJETAS
INSERT INTO TARJETAS(Red, NombreTitular, Numero, ExpDate, CVC)
VALUES
	('Visa', 'Camila Catorceno', 1234123412341234, '2025-05-29', 123),
	('MasterCard', 'Camila Catorceno', 1234123412341235, '2025-05-29', 123);

-- 7.Cliente - Tarjeta
SELECT * FROM CLIENTE_TARJETA
INSERT INTO CLIENTE_TARJETA(ClienteID, TarjetaID)
VALUES
	(1, 1),
	(1, 2);

-- 8.Datos para Factura
SELECT * FROM DATOS_FACTURA
INSERT INTO DATOS_FACTURA (RazonSocial, NitCi)
VALUES
	('Camila Catorceno', 8673021);

-- 9.Cliente Factura
SELECT * FROM CLIENTE_FACTURA
INSERT INTO CLIENTE_FACTURA(ClienteID, FacturaID)
VALUES (1, 1);

-- 10.Descuentos
SELECT * FROM DESCUENTOS
INSERT INTO DESCUENTOS(TiendaID, Nombre, Porcentaje, StartDate, EndDate)
VALUES
	 (1, 'Offer 50%', 50, '2025-05-01', '2025-06-01'),
	 (1, 'Offer 20%', 20, GETDATE(), '2025-06-01'),
	 (1, 'Offer 25%', 25, GETDATE(), DATEADD(MONTH, 1, GETDATE()));

-- 10.Inventario
SELECT * FROM INVENTARIO
INSERT INTO INVENTARIO(TiendaID, SubcategoriaID, Nombre, Precio)
VALUES
	(1, 58, 'Balon de hule', 50),
	(1, 58, 'some product', 100);

-- 11.Productos
SELECT * FROM PRODUCTOS
INSERT INTO PRODUCTOS(ItemID, ProductoID) -- ItemID se ordena de mayo a menor, wtf¿???
VALUES
	(12345678, 1),
	(87654321, 1),
	(12345679, 2);

-- Direcciones
SELECT * FROM DIRECCIONES
INSERT INTO DIRECCIONES(ClienteID, Barrio, Calle, Numero)
VALUES (1, 'Los Bosques', 'Perimetral', 570);

-- Carritos -- si se intenta eliminar un ProductoID que no existe en la tabla Items_Carrito no lanza nigún error
SELECT * FROM CARRITOS
INSERT INTO CARRITOS(ClienteID) -- se debe crear primero el carrito
VALUES (1);

-- Items de Carritos
SELECT * FROM ITEMS_CARRITO
INSERT INTO ITEMS_CARRITO(CarritoID, ProductoID, Cantidad)
VALUES 
	(1, 1, 1),
	(1, 2, 1);

-- Pedidos
SELECT * FROM PEDIDOS
-- Pagos
SELECT * FROM PAGOS

EXEC sp_realizarPedido 1, 1, 1, 1, 'Tarjeta'
SELECT * FROM CARRITOS
SELECT * FROM PEDIDOS
SELECT * FROM PAGOS

-- Detalle Pedido
SELECT * FROM DETALLE_PEDIDO
INSERT INTO DETALLE_PEDIDO(PedidoID, ItemID)
VALUES (2, 12345678);