--2. SP VIZUALIZAR FACTURAS 
CREATE OR ALTER PROCEDURE usp_VisualizarFacturas
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

        -- Mostrar facturas activas
        SELECT FacturaID, RazonSocial, NitCi, ModifiedDate
        FROM DATOS_FACTURA
        WHERE ClienteID = @ClienteID AND Estado = 'Activo'
        ORDER BY FacturaID;

        -- Devolver mensaje si no hay facturas activas
        IF @@ROWCOUNT = 0
        BEGIN
            SELECT 'No se encontraron facturas activas para el cliente.' AS Mensaje;
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