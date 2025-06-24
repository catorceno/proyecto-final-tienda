CREATE OR ALTER PROCEDURE sp_registrarNuevaTienda
    @Correo          NVARCHAR(100),
    @Password        NVARCHAR(200),
    @Nombre          NVARCHAR(50),
    @NombreJuridico  NVARCHAR(50),
    @NIT             INT,
    @Teloefono       INT,
    @CategoriaID     INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- 1. Verificar si ya existe una tienda con ese correo
        IF EXISTS (SELECT 1 FROM USERS WHERE Correo = @Correo AND Tipo = 'Tienda')
        BEGIN
            THROW 50001, 'Ya tienes una cuenta registrada.', 1;
        END

        BEGIN TRANSACTION;

        -- 2. Hashear la contraseña ingresada
        DECLARE @PasswordHash VARBINARY(64);
        SET @PasswordHash = HASHBYTES('SHA2_256', @Password);

        -- 3. Insertar en USERS
        INSERT INTO USERS (Correo, Password, Tipo, Estado)
        VALUES (@Correo, @PasswordHash, 'Tienda', 'Activo');

        DECLARE @UserID INT = SCOPE_IDENTITY();

        -- 4. Insertar en TIENDAS
        INSERT INTO TIENDAS(UserID, Nombre, NombreJuridico, NIT, Telefono, CategoriaID)
        VALUES (@UserID, @Nombre, @NombreJuridico, @NIT, @Teloefono, @CategoriaID);

        COMMIT TRANSACTION;

        -- 5. Confirmar con mensaje y datos
        SELECT 
            'Tienda registrada exitosamente.' AS Mensaje,
            @UserID AS UserID,
            RIGHT(CONVERT(VARCHAR(64), @PasswordHash, 2), 64) AS PasswordHashHex;

    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorState INT = ERROR_STATE();
        THROW 50000, @ErrorMessage, @ErrorState;
    END CATCH
END;
GO
