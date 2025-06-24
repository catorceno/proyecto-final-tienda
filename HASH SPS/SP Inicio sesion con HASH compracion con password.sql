--SP incio de sesion actualizado 
CREATE OR ALTER PROCEDURE sp_InicioSesion
    @Correo NVARCHAR(200),
    @Password NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- 1. Hashear la contraseña ingresada
        DECLARE @PasswordHash VARBINARY(64);
        SET @PasswordHash = HASHBYTES('SHA2_256', @Password);

        -- 2. Validar existencia del usuario y contraseña hasheada
        IF NOT EXISTS (
            SELECT 1 FROM USERS
            WHERE Correo = @Correo AND Password = @PasswordHash
        )
        BEGIN
            THROW 50001, 'Correo o Contraseña incorrectos.', 1;
        END

        -- 3. Validar si el usuario está inactivo
        IF EXISTS (
            SELECT 1 FROM USERS
            WHERE Correo = @Correo AND Estado = 'Inactivo'
        )
        BEGIN
            THROW 50002, 'La cuenta está inactiva.', 1;
        END

        -- 4. Si todo está bien, mostrar mensaje y datos
        SELECT 
            'Inicio de sesión exitoso.' AS Mensaje,
            UserID,
            Correo,
            Tipo,
            Estado
        FROM USERS
        WHERE Correo = @Correo AND Password = @PasswordHash;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorState INT = ERROR_STATE();
        THROW 50000, @ErrorMessage, @ErrorState;
    END CATCH
END;
GO
