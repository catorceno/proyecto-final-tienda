CREATE OR ALTER PROCEDURE sp_VerInventario
    @TiendaID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validar que la tienda exista
        IF NOT EXISTS (SELECT 1 FROM TIENDAS WHERE TiendaID = @TiendaID)
        BEGIN
            THROW 50001, 'La tienda especificada no existe.', 1;
        END

        -- Seleccionar el inventario con joins
        SELECT
            i.ProductoID,
            i.Nombre            AS Producto,
            c.Nombre            AS Categoria,
            s.Nombre            AS Subcategoria,
            i.Stock,
            i.Precio,
            d.Nombre            AS NombreDescuento,
            d.Porcentaje        AS PorcentajeDescuento,
            i.PrecioDescuento,
            i.Estado,
            i.ModifiedDate
        FROM INVENTARIO i
        INNER JOIN SUBCATEGORIAS s ON i.SubcategoriaID = s.SubcategoriaID
        INNER JOIN CATEGORIAS c ON s.CategoriaID = c.CategoriaID
        LEFT JOIN DESCUENTOS d ON i.DescuentoID = d.DescuentoID
        WHERE i.TiendaID = @TiendaID
        ORDER BY i.Nombre ASC;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorState INT = ERROR_STATE();
        THROW 50000, @ErrorMessage, @ErrorState;
    END CATCH
END;
GO
