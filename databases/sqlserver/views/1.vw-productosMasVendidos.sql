USE Tienda
GO

--view productos mas vendidos
SELECT * FROM INVENTARIO
SELECT * FROM VENTAS 
ALTER VIEW vw_ProductosMasVendidos AS
SELECT TOP 10
t.Nombre as Tienda,
inv.Nombre                         as Producto,
SUM(v.Cantidad)                    as CantidadVendida
FROM VENTAS v
INNER JOIN INVENTARIO inv ON v.ProductoID = inv.ProductoID
INNER JOIN TIENDAS t ON t.TiendaID = inv.TiendaID 
WHERE t.TiendaID = 1
GROUP BY inv.Nombre, t.Nombre
ORDER BY CantidadVendida DESC;

select * from vw_ProductosMasVendidos

SELECT TOP 1 * FROM vw_ProductosMasVendidos







SELECT * FROM PRODUCTOS
INSERT INTO INVENTARIO (TiendaID, SubcategoriaID, Nombre, Precio, Stock)
VALUES (2, 1, 'Iphone1', 100, 6);
INSERT INTO PRODUCTOS(ProductoID, Codigo)
VALUES (8, 123),
(8, 456),
(8, 789);