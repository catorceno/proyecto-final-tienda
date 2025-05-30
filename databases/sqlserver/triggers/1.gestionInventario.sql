USE Marketplace
GO

-- 1.Calcular Stock después de insertar items en la tabla Productos 
CREATE TRIGGER trg_calcularStockInsertItem
ON PRODUCTOS
AFTER INSERT
AS
BEGIN
	UPDATE inv
	SET Stock = (SELECT COUNT(*) 
				 FROM PRODUCTOS p 
				 WHERE inv.ProductoID = p.ProductoID
				 AND p.Estado = 'Disponible')
	FROM INVENTARIO inv
END;

-- 2.Calcular PrecioDescuento después de aplicar un descuento a un Producto
CREATE TRIGGER trg_calcularPrecioDescuento
ON INVENTARIO
AFTER UPDATE
AS
BEGIN
	UPDATE inv
	SET PrecioDescuento =
		CASE WHEN i.DescuentoID IS NULL THEN NULL
		ELSE i.Precio - (i.Precio * ds.Porcentaje) / 100
		END
	FROM INVENTARIO inv
	INNER JOIN inserted i ON inv.ProductoID = i.ProductoID
	LEFT JOIN deleted d   ON inv.ProductoID = d.ProductoID
	LEFT JOIN DESCUENTOS ds ON i.DescuentoID = ds.DescuentoID
	WHERE (d.DescuentoID IS NULL     AND i.DescuentoID IS NOT NULL)
	   OR (d.DescuentoID IS NOT NULL AND i.DescuentoID IS NOT NULL AND d.DescuentoID <> i.DescuentoID)
	   OR (d.DescuentoID IS NOT NULL AND i.DescuentoID IS NULL)
	   OR (i.PrecioDescuento IS NOT NULL AND i.Precio <> d.Precio)
END;

-- 3.Recalcular Stock después de una venta
CREATE TRIGGER trg_calcularStockAfterVenta
ON PRODUCTOS
AFTER UPDATE
AS
BEGIN
	UPDATE inv
	SET Stock = (SELECT COUNT(*) 
				 FROM PRODUCTOS p 
				 WHERE inv.ProductoID = p.ProductoID
				 AND p.Estado = 'Disponible')
	FROM INVENTARIO inv
END;