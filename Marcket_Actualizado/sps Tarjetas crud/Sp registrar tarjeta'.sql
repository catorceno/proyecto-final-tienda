--4. Registrar tarjeta 
--ejecutado
CREATE OR ALTER PROCEDURE usp_RegistrarTarjeta
    @ClienteID INT,
    @Red NVARCHAR(20),
    @NombreTitular NVARCHAR(50),
    @Numero BIGINT,
    @CVC INT,
    @ExpDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validar que ClienteID existe
        IF NOT EXISTS (SELECT 1 FROM CLIENTES WHERE ClienteID = @ClienteID)
        BEGIN
            THROW 50001, 'El ClienteID especificado no existe.', 1;
        END

        -- Validar par�metros no vac�os
        IF @Red IS NULL OR @Red = '' OR @NombreTitular IS NULL OR @NombreTitular = ''
        BEGIN
            THROW 50002, 'Red y NombreTitular no pueden estar vac�os.', 1;
        END

        -- Validar Red
        IF @Red NOT IN ('Visa', 'MasterCard')
        BEGIN
            THROW 50003, 'La red debe ser Visa o MasterCard.', 1;
        END

        -- Validar Numero
        IF @Numero < 1000000000000000 OR @Numero > 9999999999999999
        BEGIN
            THROW 50004, 'El n�mero de tarjeta debe tener 16 d�gitos.', 1;
        END

        -- Validar CVC
        IF @CVC < 100 OR @CVC > 999
        BEGIN
            THROW 50005, 'El CVC debe tener 3 d�gitos.', 1;
        END

        -- Validar ExpDate
        IF @ExpDate <= CAST(GETDATE() AS DATE)
        BEGIN
            THROW 50006, 'La fecha de expiraci�n debe ser futura.', 1;
        END

        BEGIN TRANSACTION;

        -- Validar duplicados (por restricci�n UNIQUE)
        IF EXISTS (
            SELECT 1
            FROM TARJETAS
            WHERE NombreTitular = @NombreTitular
            AND Numero = @Numero
            AND CVC = @CVC
            AND Estado = 'Activo'
        )
        BEGIN
            THROW 50007, 'Esta tarjeta ya est� registrada y activa.', 1;
        END

        -- Insertar la tarjeta
        INSERT INTO TARJETAS (ClienteID, Red, NombreTitular, Numero, CVC, ExpDate, Estado)
        VALUES (@ClienteID, @Red, @NombreTitular, @Numero, @CVC, @ExpDate, 'Activo');

        COMMIT TRANSACTION;

        -- Devolver mensaje de �xito
        SELECT 'Tarjeta registrada exitosamente.' AS Mensaje, 
               SCOPE_IDENTITY() AS TarjetaID;
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