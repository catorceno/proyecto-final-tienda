USE ProcesoVenta
GO

SELECT * FROM TIENDAS
SELECT * FROM DESCUENTOS
SELECT * FROM INVENTARIO
SELECT * FROM PRODUCTOS
INSERT INTO TIENDAS(Nombre, NombreJuridico, NIT, Telefono)
VALUES 
	('some tienda', 'some tienda SA', 123456789, 12345678),
	('other tienda', 'other tienda SA', 223456789, 22345678);
INSERT INTO DESCUENTOS(TiendaID, Nombre, Porcentaje, StartDate)
VALUES (1, 'some descuento', 50, '2025-05-27');
INSERT INTO INVENTARIO(TiendaID, Nombre, Precio, Stock)
VALUES 
	(1, 'some product', 100, 5),
	(1, 'some product2', 50, 5),
	(2, 'other product', 200, 5);
INSERT INTO PRODUCTOS(ProductoID, Codigo)
VALUES
	(1, 111),
	(1, 112),
	(1, 113),
	(1, 114),
	(1, 115),
	(2, 121),
	(2, 122),
	(2, 123),
	(2, 124),
	(2, 125), -- se muestra como 0 en lugar de 000
	(3, 211),
	(3, 212),
	(3, 213),
	(3, 214),
	(3, 215);

-- se crea una venta por cada Producto diferente agregado
-- se crea un detalleVenta con los items concretos que se han vendido
SELECT * FROM INVENTARIO
SELECT * FROM PRODUCTOS
SELECT * FROM COMPRAS
SELECT * FROM VENTAS
SELECT * FROM DETALLE_VENTA -- empieza en 2
INSERT INTO COMPRAS(ClienteID, Subtotal, ServiceFee, Total)
VALUES 
	(1, 200, 5, 205),
	(2, 500, 5, 505);
INSERT INTO VENTAS(CompraID, ProductoID, Cantidad, PrecioUnitario, OrderDate, ShipDate)
VALUES 
	(1, 1, 1, 100, GETDATE(), GETDATE()),
	(1, 2, 2, 50, GETDATE(), GETDATE()),
	(2, 1, 3, 100, GETDATE(), GETDATE()),
	(2, 3, 1, 200, GETDATE(), GETDATE());
INSERT INTO DETALLE_VENTA(VentaID, ItemID)
VALUES 
	(1, 1), -- producto 1
	(2, 6), -- producto 2
	(2, 7),
	(3, 2), -- producto 1
	(3, 3),
	(3, 4),
	(4, 11); -- producto 3

SELECT * FROM INVENTARIO
SELECT * FROM PRODUCTOS
SELECT * FROM COMPRAS
SELECT * FROM VENTAS
SELECT * FROM DETALLE_VENTA
-- consultar  de una tienda
SELECT
	v.CompraID,
	t.Nombre,
	inv.Nombre,
	v.Cantidad
FROM VENTAS v
INNER JOIN INVENTARIO inv ON v.ProductoID = inv.ProductoID
INNER JOIN TIENDAS    t   ON inv.TiendaID = t.TiendaID
WHERE t.TiendaID = 1

-- contar las ventas de una tienda
SELECT
	t.Nombre,
	COUNT(DISTINCT v.CompraID) AS CantidadCompras
FROM VENTAS v
INNER JOIN INVENTARIO inv ON v.ProductoID = inv.ProductoID
INNER JOIN TIENDAS    t   ON inv.TiendaID = t.TiendaID
WHERE t.TiendaID = 1
GROUP BY t.Nombre 

-- consultar la compra de cada cliente


-- se crea un detalleCarrito por cada Productodiferente agregado
SELECT * FROM Carrito
SELECT * FROM DetalleCarrito 
INSERT INTO Carrito(Subtotal, ServiceFee, Total)
VALUES (500, 5, 505);
INSERT INTO DetalleCarrito(CarritoID, ProductoID, Cantidad, PrecioUnitario)
VALUES 
	(1, 1, 3, 100),
	(1, 2, 1, 200);

-- Consultar las venta de cada tienda usando Carrito
SELECT * FROM DetalleCarrito
SELECT * FROM VENTAS
SELECT * FROM DETALLE_VENTA
SELECT * FROM PRODUCTOS
SELECT
	t.Nombre,
	inv.Nombre,
	cd.Cantidad,
	p.codigo,
	v.OrderDate
FROM VENTAS v
INNER JOIN DetalleCarrito cd ON v.DetalleCarritoID = cd.DetalleCarritoID
INNER JOIN INVENTARIO inv    ON cd.ProductoID	   = inv.ProductoID
INNER JOIN DETALLE_VENTA dv  ON v.VentaID		   = dv.VentaID
INNER JOIN PRODUCTOS p       ON dv.ItemID		   = p.ItemID
INNER JOIN TIENDAS t		 ON inv.TiendaID	   = t.TiendaID

SELECT
	p.codigo
FROM VENTAS v
INNER JOIN DetalleCarrito cd ON v.DetalleCarritoID = cd.DetalleCarritoID
INNER JOIN INVENTARIO inv    ON cd.ProductoID	   = inv.ProductoID
INNER JOIN DETALLE_VENTA dv  ON v.VentaID		   = dv.VentaID
INNER JOIN PRODUCTOS p       ON dv.ItemID		   = p.ItemID
INNER JOIN TIENDAS t		 ON inv.TiendaID	   = t.TiendaID
WHERE t.TiendaID = 1 AND inv.ProductoID = 1

SELECT
	p.codigo
FROM VENTAS v
INNER JOIN DetalleCarrito cd ON v.DetalleCarritoID = cd.DetalleCarritoID
INNER JOIN INVENTARIO inv    ON cd.ProductoID	   = inv.ProductoID
INNER JOIN DETALLE_VENTA dv  ON v.VentaID		   = dv.VentaID
INNER JOIN PRODUCTOS p       ON dv.ItemID		   = p.ItemID
INNER JOIN TIENDAS t		 ON inv.TiendaID	   = t.TiendaID
WHERE t.TiendaID = 2 AND inv.ProductoID = 2