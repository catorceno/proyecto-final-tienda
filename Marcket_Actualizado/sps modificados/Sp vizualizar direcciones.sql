--2. Vizualizar direcciones 
--Cambios:
--Agrega Estado = 'Activo' en la condición WHERE.
--Actualiza el mensaje para reflejar que solo se muestran direcciones activas.
CREATE OR ALTER PROCEDURE usp_VisualizarDirecciones
    @ClienteID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validar que ClienteID existe
        IF NOT EXISTS (SELECT 1 FROM CLIENTES WHERE ClienteID = @ClienteID)
        BEGIN
            THROW 50001, 'El ClienteID especificado no existe.', 1;
        END

        -- Mostrar direcciones activas
        SELECT DireccionID, Barrio, Calle, Numero, ModifiedDate
        FROM DIRECCIONES
        WHERE ClienteID = @ClienteID AND Estado = 'Activo'
        ORDER BY DireccionID;

        -- Devolver mensaje si no hay direcciones activas
        IF @@ROWCOUNT = 0
        BEGIN
            SELECT 'No se encontraron direcciones activas para el cliente.' AS Mensaje;
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