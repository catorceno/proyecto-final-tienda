USE Marketplace
GO

--------------- GESTI�N DE INVENTARIO ---------------
-- 1.trg_calcularStockInsertItem
SELECT * FROM INVENTARIO 
SELECT * FROM PRODUCTOS
INSERT INTO PRODUCTOS (Codigo, ProductoID)
VALUES (999, 1);

-- 2.trg_calcularPrecioDescuento
SELECT * FROM INVENTARIO 
UPDATE INVENTARIO 
SET DescuentoID = 1
WHERE ProductoID = 1

-- 3.trg_calcularStockAfterVenta
SELECT * FROM INVENTARIO 
SELECT * FROM PRODUCTOS
UPDATE PRODUCTOS
SET Estado = 'Vendido'
WHERE ItemID = 22

--------------- GESTI�N DE VENTAS ---------------
-- 1.trg_cambiarItemAVendido
SELECT * FROM VENTAS
SELECT * FROM DETALLE_VENTA
SELECT * FROM PRODUCTOS
INSERT INTO DETALLE_VENTA(VentaID, ItemID)
VALUES (1, 1);