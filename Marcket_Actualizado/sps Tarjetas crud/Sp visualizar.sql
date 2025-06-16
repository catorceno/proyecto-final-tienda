--1. sp visualizar tarjetas 
	CREATE OR ALTER PROCEDURE usp_VisualizarTarjetas
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

        -- Mostrar tarjetas activas
        SELECT TarjetaID, Red, NombreTitular, RIGHT(CAST(Numero AS NVARCHAR(16)), 4) AS UltimosDigitos, 
               CVC, ExpDate, ModifiedDate
        FROM TARJETAS
        WHERE ClienteID = @ClienteID AND Estado = 'Activo'
        ORDER BY TarjetaID;

        -- Devolver mensaje si no hay tarjetas activas
        IF @@ROWCOUNT = 0
        BEGIN
            SELECT 'No se encontraron tarjetas activas para el cliente.' AS Mensaje;
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