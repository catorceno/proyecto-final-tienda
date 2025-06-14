CREATE OR ALTER PROCEDURE usp_EliminarDireccion
    @DireccionID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validar que DireccionID existe
        IF NOT EXISTS (SELECT 1 FROM DIRECCIONES WHERE DireccionID = @DireccionID)
        BEGIN
            THROW 50001, 'La dirección especificada no existe.', 1;
        END

        -- Verificar si la dirección está referenciada en COMPRAS
        IF EXISTS (SELECT 1 FROM COMPRAS WHERE DireccionID = @DireccionID)
        BEGIN
            THROW 50002, 'No se puede eliminar la dirección porque está asociada a una o más compras.', 1;
        END

        BEGIN TRANSACTION;

        -- Eliminar la dirección
        DELETE FROM DIRECCIONES
        WHERE DireccionID = @DireccionID;

        COMMIT TRANSACTION;

        -- Devolver mensaje de éxito
        SELECT 'Dirección eliminada exitosamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        THROW 50000, @ErrorMessage, @ErrorState;
    END CATCH
END;
GO