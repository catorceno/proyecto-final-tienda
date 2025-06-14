--2. sp editar direccion 
CREATE PROCEDURE sp_editarDireccion
    @DireccionID INT,
    @Barrio NVARCHAR(50),
    @Calle NVARCHAR(50),
    @Numero INT
AS
BEGIN
	BEGIN TRY	
        BEGIN TRANSACTION
            -- Verificar que la dirección existe
            IF NOT EXISTS (SELECT 1 FROM DIRECCIONES WHERE DireccionID = @DireccionID)
            BEGIN
                THROW 50010, 'La dirección especificada no existe.', 1;
            END
            
            -- Verificar que no se duplique
            DECLARE @ClienteID INT = (SELECT ClienteID FROM DIRECCIONES WHERE DireccionID = @DireccionID);
            
            IF EXISTS (
                SELECT 1
                FROM DIRECCIONES 
                WHERE DireccionID <> @DireccionID
                AND ClienteID = @ClienteID
                AND Barrio = @Barrio
                AND Calle = @Calle
                AND Numero = @Numero
            )
            BEGIN
                THROW 50015, 'Ya existe otra dirección idéntica para este cliente.', 1;
            END
            
            -- Actualizar
            UPDATE DIRECCIONES
            SET Barrio = @Barrio,
                Calle = @Calle,
                Numero = @Numero,
                ModifiedDate = GETDATE()
            WHERE DireccionID = @DireccionID;
            
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

select * from DIRECCIONES
