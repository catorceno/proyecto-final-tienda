--ahora pasamos a las correcciones de los sps afectados
--1. Eliminar direcciones 
--Cambios:
--Cambios:
--Reemplaza DELETE por UPDATE para cambiar Estado a 'Inactivo'.
--Agrega validaci�n para evitar marcar como inactiva una direcci�n que ya lo est�.
--Elimina la verificaci�n de referencias en COMPRAS, ya que no es necesario
CREATE OR ALTER PROCEDURE usp_EliminarDireccion
    @DireccionID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validar que DireccionID existe
        IF NOT EXISTS (SELECT 1 FROM DIRECCIONES WHERE DireccionID = @DireccionID)
        BEGIN
            THROW 50001, 'La direcci�n especificada no existe.', 1;
        END

        -- Validar que la direcci�n no est� ya inactiva
        IF EXISTS (SELECT 1 FROM DIRECCIONES WHERE DireccionID = @DireccionID AND Estado = 'Inactivo')
        BEGIN
            THROW 50002, 'La direcci�n ya est� inactiva.', 1;
        END

        BEGIN TRANSACTION;

        -- Marcar como inactiva
        UPDATE DIRECCIONES
        SET Estado = 'Inactivo',
            ModifiedDate = GETDATE()
        WHERE DireccionID = @DireccionID;

        COMMIT TRANSACTION;

        -- Devolver mensaje de �xito
        SELECT 'Direcci�n marcada como inactiva exitosamente.' AS Mensaje;
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

