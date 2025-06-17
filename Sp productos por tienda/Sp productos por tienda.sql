use Marcket_Actualizado

select * from TIENDAS
--sp para ver productos por tienda 
--ejecutado
CREATE OR ALTER PROCEDURE usp_VerProductosPorTienda
    @TiendaID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validar que TiendaID existe
        IF NOT EXISTS (SELECT 1 FROM TIENDAS WHERE TiendaID = @TiendaID)
        BEGIN
            THROW 50001, 'La tienda especificada no existe.', 1;
        END

        -- Mostrar productos por TiendaID
        SELECT 
            I.ProductoID,
            I.Nombre,
            I.Precio,
            I.PrecioDescuento,
            I.Stock,
            I.Estado,
            S.Nombre AS Subcategoria,
            C.Nombre AS Categoria
        FROM INVENTARIO I
        INNER JOIN SUBCATEGORIAS S ON I.SubcategoriaID = S.SubcategoriaID
        INNER JOIN CATEGORIAS C ON S.CategoriaID = C.CategoriaID
        WHERE I.TiendaID = @TiendaID
        AND I.Estado = 'Disponible' -- Filtra solo productos disponibles
        ORDER BY I.Nombre;

        -- Devolver mensaje si no hay productos
        IF @@ROWCOUNT = 0
        BEGIN
            SELECT 'No se encontraron productos disponibles en esta tienda.' AS Mensaje;
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        THROW 50000, @ErrorMessage, @ErrorState;
    END CATCH
END;
GO