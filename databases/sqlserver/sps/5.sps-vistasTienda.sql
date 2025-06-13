USE Tienda
GO

-- 1.
CREATE PROCEDURE sp_verVentas
@TiendaID INT
AS BEGIN
	SELECT
		t.Nombre as Tienda,
		v.VentaID,
		inv.Nombre as Producto,
		v.Cantidad, v.PrecioUnitario,
		c.Subtotal, -- (v.Cantidad * v.PrecioUnitario) as Subtotal,
		c.ServiceFee, 
		c.Total, -- (v.Cantidad * v.PrecioUnitario) + c.ServiceFee as Total,
		v.OrderDate, v.ShipDate
	FROM VENTAS v
	INNER JOIN COMPRAS c ON v.CompraID = c.CompraID
	INNER JOIN INVENTARIO inv ON v.ProductoID = inv.ProductoID
	INNER JOIN TIENDAS t ON inv.TiendaID = t.TiendaID
	WHERE t.TiendaID = @TiendaID
    ORDER BY v.OrderDate DESC; -- alter...
END;
-- como hacer para que se vean todos los productos de una misma compra?
