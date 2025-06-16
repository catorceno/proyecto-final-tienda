--3. Eliminar Trjeta 
--ejecutado 
CREATE OR ALTER PROCEDURE usp_EliminarTarjeta
    @TarjetaID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validar que TarjetaID existe
        IF NOT EXISTS (SELECT 1 FROM TARJETAS WHERE TarjetaID = @TarjetaID)
        BEGIN
            THROW 50001, 'La tarjeta especificada no existe.', 1;
        END

        -- Validar que la tarjeta no esté ya inactiva
        IF EXISTS (SELECT 1 FROM TARJETAS WHERE TarjetaID = @TarjetaID AND Estado = 'Inactivo')
        BEGIN
            THROW 50002, 'La tarjeta ya está inactiva.', 1;
        END

        BEGIN TRANSACTION;

        -- Marcar como inactiva
        UPDATE TARJETAS
        SET Estado = 'Inactivo',
            ModifiedDate = GETDATE()
        WHERE TarjetaID = @TarjetaID;

        COMMIT TRANSACTION;

        -- Devolver mensaje de éxito
        SELECT 'Tarjeta marcada como inactiva exitosamente.' AS Mensaje;
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