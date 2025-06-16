--2. sp editar tarjetas 
--ejecutado
CREATE OR ALTER PROCEDURE usp_EditarTarjeta
    @TarjetaID INT,
    @Red NVARCHAR(20),
    @NombreTitular NVARCHAR(50),
    @Numero BIGINT,
    @CVC INT,
    @ExpDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validar que TarjetaID existe
        IF NOT EXISTS (SELECT 1 FROM TARJETAS WHERE TarjetaID = @TarjetaID)
        BEGIN
            THROW 50001, 'La tarjeta especificada no existe.', 1;
        END

        -- Validar que la tarjeta esté activa
        IF EXISTS (SELECT 1 FROM TARJETAS WHERE TarjetaID = @TarjetaID AND Estado = 'Inactivo')
        BEGIN
            THROW 50002, 'No se puede editar una tarjeta inactiva.', 1;
        END

        -- Validar parámetros no vacíos
        IF @Red IS NULL OR @Red = '' OR @NombreTitular IS NULL OR @NombreTitular = ''
        BEGIN
            THROW 50003, 'Red y NombreTitular no pueden estar vacíos.', 1;
        END

        -- Validar Red
        IF @Red NOT IN ('Visa', 'MasterCard')
        BEGIN
            THROW 50004, 'La red debe ser Visa o MasterCard.', 1;
        END

        -- Validar Numero
        IF @Numero < 1000000000000000 OR @Numero > 9999999999999999
        BEGIN
            THROW 50005, 'El número de tarjeta debe tener 16 dígitos.', 1;
        END

        -- Validar CVC
        IF @CVC < 100 OR @CVC > 999
        BEGIN
            THROW 50006, 'El CVC debe tener 3 dígitos.', 1;
        END

        -- Validar ExpDate
        IF @ExpDate <= CAST(GETDATE() AS DATE)
        BEGIN
            THROW 50007, 'La fecha de expiración debe ser futura.', 1;
        END

        BEGIN TRANSACTION;

        -- Validar duplicados (excluyendo la tarjeta actual)
        IF EXISTS (
            SELECT 1
            FROM TARJETAS
            WHERE NombreTitular = @NombreTitular
            AND Numero = @Numero
            AND CVC = @CVC
            AND TarjetaID != @TarjetaID
            AND Estado = 'Activo'
        )
        BEGIN
            THROW 50008, 'Ya existe otra tarjeta activa idéntica.', 1;
        END

        -- Actualizar la tarjeta
        UPDATE TARJETAS
        SET Red = @Red,
            NombreTitular = @NombreTitular,
            Numero = @Numero,
            CVC = @CVC,
            ExpDate = @ExpDate,
            Estado = 'Activo',
            ModifiedDate = GETDATE()
        WHERE TarjetaID = @TarjetaID;

        COMMIT TRANSACTION;

        -- Devolver mensaje de éxito
        SELECT 'Tarjeta actualizada exitosamente.' AS Mensaje, 
               @TarjetaID AS TarjetaID;
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