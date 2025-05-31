USE Tienda
GO

-- 1.
CREATE PROCEDURE sp_productosDeUnaTienda
@TiendaID INT
AS BEGIN
	SELECT
        i.ProductoID,
        i.Nombre            AS NombreProducto,
        c.Nombre            AS Categoria,
        s.Nombre            AS Subcategoria,
        i.Precio,
        i.Stock,
        d.Nombre            AS NombreDescuento,
        d.Porcentaje        AS PorcentajeDescuento,
        i.PrecioDescuento
    FROM INVENTARIO i
    INNER JOIN SUBCATEGORIAS s ON i.SubcategoriaID = s.SubcategoriaID
    INNER JOIN CATEGORIAS c ON s.CategoriaID = c.CategoriaID
    LEFT JOIN DESCUENTOS d ON i.DescuentoID = d.DescuentoID
    WHERE i.TiendaID = @TiendaID
    ORDER BY i.Nombre;
END;

-- 2.
ALTER PROCEDURE sp_ventasDeUnaTienda
@TiendaID INT
AS BEGIN
	SELECT
        v.OrderDate        AS FechaPedido,
        v.ShipDate         AS FechaEnvio,
        i.Nombre           AS NombreProducto,
        v.Cantidad,
        v.PrecioUnitario,
        (v.Cantidad * v.PrecioUnitario) AS ImporteLinea
    FROM VENTAS v
    INNER JOIN COMPRAS cp ON v.CompraID = cp.CompraID
    INNER JOIN CLIENTES cli ON cp.ClienteID = cli.ClienteID
    INNER JOIN INVENTARIO i ON v.ProductoID = i.ProductoID
    WHERE i.TiendaID = @TiendaID
    ORDER BY v.OrderDate DESC;
END;