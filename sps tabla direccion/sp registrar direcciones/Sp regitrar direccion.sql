use Marcketplace
--sp en tabla direcciones 
CREATE PROCEDURE sp_registrarDireccion
    @ClienteID INT,
    @Barrio NVARCHAR(50),
    @Calle NVARCHAR(50),
    @Numero INT,
    @NuevaDireccionID INT OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            IF EXISTS (
                SELECT 1
                FROM DIRECCIONES 
                WHERE ClienteID = @ClienteID 
                AND Barrio = @Barrio
                AND Calle = @Calle
                AND Numero = @Numero
            )
            BEGIN
                THROW 50005, 'Esta dirección ya fue registrada.', 1;
            END
            
            INSERT INTO DIRECCIONES(ClienteID, Barrio, Calle, Numero)
            VALUES (@ClienteID, @Barrio, @Calle, @Numero);
            
            SET @NuevaDireccionID = SCOPE_IDENTITY();
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;	
    END CATCH
END;