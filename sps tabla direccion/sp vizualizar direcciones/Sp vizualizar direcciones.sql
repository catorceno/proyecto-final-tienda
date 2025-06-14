--4. vizualizar direcciones 
CREATE OR ALTER PROCEDURE usp_VisualizarDirecciones
    @ClienteID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @ClienteID IS NULL
        BEGIN
            -- Mostrar todas las direcciones
            SELECT 
                DireccionID,
                ClienteID,
                Barrio,
                Calle,
                Numero,
                ModifiedDate
            FROM DIRECCIONES;
        END
        ELSE
        BEGIN
            -- Validar que el cliente existe
            IF NOT EXISTS (SELECT 1 FROM CLIENTES WHERE ClienteID = @ClienteID)
            BEGIN
                THROW 50001, 'El ClienteID especificado no existe.', 1;
            END

            -- Mostrar direcciones del cliente
            SELECT 
                DireccionID,
                ClienteID,
                Barrio,
                Calle,
                Numero,
                ModifiedDate
            FROM DIRECCIONES
            WHERE ClienteID = @ClienteID;

            -- Avisar si no hay direcciones
            IF @@ROWCOUNT = 0
            BEGIN
                SELECT 'No se encontraron direcciones para el cliente.' AS Mensaje;
            END
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
