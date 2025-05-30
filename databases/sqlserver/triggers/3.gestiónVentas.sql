USE Marketplace 
GO

-- 1.Después de insertar items a la tabla DetalleVenta, marcar como 'Vendido' en la tabla Productos
CREATE TRIGGER trg_cambiarItemAVendido
ON DETALLE_VENTA 
AFTER INSERT
AS 
BEGIN
	UPDATE p 
	SET Estado = 'Vendido'
	FROM PRODUCTOS p
	INNER JOIN DETALLE_VENTA dv ON p.ItemID = dv.ItemID
END;