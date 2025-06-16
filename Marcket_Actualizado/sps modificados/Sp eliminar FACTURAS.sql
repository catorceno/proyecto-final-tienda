--sp en tabla facturas
--1. eliminar facturas 
CREATE OR ALTER PROCEDURE usp_EliminarFactura
    @FacturaID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validar que FacturaID existe
        IF NOT EXISTS (SELECT 1 FROM DATOS_FACTURA WHERE FacturaID = @FacturaID)
        BEGIN
            THROW 50001, 'La factura especificada no existe.', 1;
        END

        -- Validar que la factura no esté ya inactiva
        IF EXISTS (SELECT 1 FROM DATOS_FACTURA WHERE FacturaID = @FacturaID AND Estado = 'Inactivo')
        BEGIN
            THROW 50002, 'La factura ya está inactiva.', 1;
        END

        BEGIN TRANSACTION;

        -- Marcar como inactiva
        UPDATE DATOS_FACTURA
        SET Estado = 'Inactivo',
            ModifiedDate = GETDATE()
        WHERE FacturaID = @FacturaID;

        COMMIT TRANSACTION;

        -- Devolver mensaje de éxito
        SELECT 'Factura marcada como inactiva exitosamente.' AS Mensaje;
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