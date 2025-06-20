CREATE PROCEDURE GetProductDetails
    @ProductoID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        i.ProductoID,
        t.Nombre AS NombreTienda,
        i.Nombre AS NombreProducto,
        i.Descripcion,
        i.Precio,
        CASE 
            WHEN d.Porcentaje IS NOT NULL THEN i.Precio * (1 - d.Porcentaje / 100.0)
            ELSE NULL 
        END AS PrecioDescuento,
        d.Porcentaje AS PorcentajeDescuento
    FROM INVENTARIO i
    INNER JOIN TIENDAS t ON i.TiendaID = t.TiendaID
    LEFT JOIN DESCUENTOS d ON i.DescuentoID = d.DescuentoID
    WHERE i.ProductoID = @ProductoID
    AND i.Estado = 'Disponible'
    AND (d.DescuentoID IS NULL OR (d.StartDate <= GETDATE() AND (d.EndDate IS NULL OR d.EndDate >= GETDATE())));
END;