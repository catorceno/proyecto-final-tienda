--4.sp Editar direccion
--cambios 
-- 
CREATE OR ALTER PROCEDURE usp_EditarDireccion
    @DireccionID INT,
    @Barrio NVARCHAR(50),
    @Calle NVARCHAR(50),
    @Numero INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY 
        -- Validar que DireccionID existe
        IF NOT EXISTS (SELECT 1 FROM DIRECCIONES WHERE DireccionID = @DireccionID)
        BEGIN
            THROW 50001, 'La dirección especificada no existe.', 1;
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

        -- Validar duplicados (excluyendo la dirección actual)
        IF EXISTS (
            SELECT 1
            FROM DIRECCIONES
            WHERE ClienteID = (SELECT ClienteID FROM DIRECCIONES WHERE DireccionID = @DireccionID)
            AND Barrio = @Barrio
            AND Calle = @Calle
            AND Numero = @Numero
            AND DireccionID != @DireccionID
            AND Estado = 'Activo'
        )
        BEGIN
            THROW 50004, 'Ya existe otra dirección activa idéntica para este cliente.', 1;
        END

        -- Actualizar la dirección
        UPDATE DIRECCIONES
        SET Barrio = @Barrio,
            Calle = @Calle,
            Numero = @Numero,
            Estado = 'Activo',
            ModifiedDate = GETDATE()
        WHERE DireccionID = @DireccionID;

        COMMIT TRANSACTION;

        -- Devolver mensaje de éxito
        SELECT 'Dirección actualizada exitosamente.' AS Mensaje, 
               @DireccionID AS DireccionID;
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