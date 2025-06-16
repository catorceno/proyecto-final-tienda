--3. sp Registrar direccion 
--cambios
--En usp_RegistrarDireccion, incluye Estado = 'Activo' en la inserción.
CREATE OR ALTER PROCEDURE usp_RegistrarDireccion
    @ClienteID INT,
    @Barrio NVARCHAR(50),
    @Calle NVARCHAR(50),
    @Numero INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validar que ClienteID existe
        IF NOT EXISTS (SELECT 1 FROM CLIENTES WHERE ClienteID = @ClienteID)
        BEGIN
            THROW 50001, 'El ClienteID especificado no existe.', 1;
        END

        -- Validar parámetros no vacíos
        IF @Barrio IS NULL OR @Barrio = '' OR @Calle IS NULL OR @Calle = ''
        BEGIN
            THROW 50002, 'Barrio y Calle no pueden estar vacíos.', 1;
        END

        -- Validar que Numero sea positivo
        IF @Numero <= 0
        BEGIN
            THROW 50003, 'El número de dirección debe ser positivo.', 1;
        END

        BEGIN TRANSACTION;

        -- Validar duplicados
        IF EXISTS (
            SELECT 1
            FROM DIRECCIONES
            WHERE ClienteID = @ClienteID
            AND Barrio = @Barrio
            AND Calle = @Calle
            AND Numero = @Numero
            AND Estado = 'Activo'
        )
        BEGIN
            THROW 50004, 'Esta dirección ya está registrada y activa para el cliente.', 1;
        END

        -- Insertar la dirección
        INSERT INTO DIRECCIONES (ClienteID, Barrio, Calle, Numero, Estado)
        VALUES (@ClienteID, @Barrio, @Calle, @Numero, 'Activo');

        COMMIT TRANSACTION;

        -- Devolver mensaje de éxito
        SELECT 'Dirección registrada exitosamente.' AS Mensaje, 
               SCOPE_IDENTITY() AS DireccionID;
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