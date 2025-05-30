USE Tienda
GO

--------------- GESTIÓN DE INVENTARIO ---------------
-- 1.trg_calcularStockInsertItem
SELECT * FROM INVENTARIO 
SELECT * FROM PRODUCTOS
ORDER BY ItemID DESC
INSERT INTO PRODUCTOS (Codigo, ProductoID)
VALUES (999, 1);

-- 2.trg_calcularPrecioDescuento
SELECT * FROM INVENTARIO 
UPDATE INVENTARIO 
SET DescuentoID = 1
WHERE ProductoID = 6

-- 3.trg_calcularStockAfterVenta
SELECT * FROM INVENTARIO 
SELECT * FROM PRODUCTOS WHERE ProductoID = 1 
UPDATE PRODUCTOS
SET Estado = 'Vendido'
WHERE ItemID = 1

--------------- GESTIÓN DE VENTAS ---------------
-- 1.trg_cambiarItemAVendido
SELECT * FROM VENTAS
SELECT * FROM DETALLE_VENTA
SELECT * FROM PRODUCTOS
INSERT INTO DETALLE_VENTA(VentaID, ItemID)
VALUES (1, 3);