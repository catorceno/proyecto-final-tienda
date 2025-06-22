--sp aplicar descuento 
CREATE OR ALTER PROCEDURE sp_AplicarDescuentoProducto
    @ProductoID INT,
    @PorcentajeDescuento DECIMAL(5,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Validar que el producto exista
        IF NOT EXISTS (SELECT 1 FROM INVENTARIO WHERE ProductoID = @ProductoID)
        BEGIN
            THROW 50001, 'El producto especificado no existe.', 1;
        END

        -- Validar que el porcentaje esté en rango válido (ej: 0 < % < 100)
        IF @PorcentajeDescuento <= 0 OR @PorcentajeDescuento >= 100
        BEGIN
            THROW 50002, 'El porcentaje de descuento debe estar entre 0 y 100.', 1;
        END

        BEGIN TRANSACTION;

        -- Aplicar descuento y calcular precio con descuento
        UPDATE INVENTARIO
        SET PrecioDescuento = Precio - (Precio * @PorcentajeDescuento / 100.0),
            ModifiedDate = GETDATE()
        WHERE ProductoID = @ProductoID;

        COMMIT TRANSACTION;

        SELECT 'Descuento aplicado correctamente.' AS Mensaje;

    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorState INT = ERROR_STATE();
        THROW 50000, @ErrorMessage, @ErrorState;
    END CATCH
END;
GO


