--ahora pasamos a las correcciones de los sps afectados
--1. Eliminar direcciones 
--Cambios:
--Cambios:
--Reemplaza DELETE por UPDATE para cambiar Estado a 'Inactivo'.
--Agrega validación para evitar marcar como inactiva una dirección que ya lo está.
--Elimina la verificación de referencias en COMPRAS, ya que no es necesario
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

        -- Validar que la dirección no esté ya inactiva
        IF EXISTS (SELECT 1 FROM DIRECCIONES WHERE DireccionID = @DireccionID AND Estado = 'Inactivo')
        BEGIN
            THROW 50002, 'La dirección ya está inactiva.', 1;
        END

        BEGIN TRANSACTION;

        -- Marcar como inactiva
        UPDATE DIRECCIONES
        SET Estado = 'Inactivo',
            ModifiedDate = GETDATE()
        WHERE DireccionID = @DireccionID;

        COMMIT TRANSACTION;

        -- Devolver mensaje de éxito
        SELECT 'Dirección marcada como inactiva exitosamente.' AS Mensaje;
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

