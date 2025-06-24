--sp registrar producto practicando 
use Marcket_Actualizado

CREATE OR ALTER PROCEDURE sp_RegistrarNuevosClientes 
    @Correo NVARCHAR(100),
    @Password NVARCHAR(200),
    @Nombre NVARCHAR(50),
    @Apellido NVARCHAR(50),
    @Telefono INT 
AS 
BEGIN 
    SET NOCOUNT ON;

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM USERS WHERE Correo = @Correo AND Tipo = 'Cliente')
        BEGIN 
            THROW 50001, 'Ya tienes una cuenta registrada.', 1;
        END 

        BEGIN TRANSACTION;

        -- 1. Hashear la contraseña
        DECLARE @PasswordHash VARBINARY(64);
        SET @PasswordHash = HASHBYTES('SHA2_256', @Password); --HASHBYTES es una funcion en sql server que calcula	el jash en la entrada en nuestro caso es pasword
		--sha256 devuelve la contraseña en binario no legible para nosotros

        -- 2. Insertar en USERS
        INSERT INTO USERS(Correo, Password, Tipo, Estado)
        VALUES(@Correo, @PasswordHash, 'Cliente', 'Activo');

        DECLARE @UserID INT = SCOPE_IDENTITY();

        -- 3. Insertar en CLIENTES
        INSERT INTO CLIENTES(UserID, Nombre, Apellido, Telefono)
        VALUES(@UserID, @Nombre, @Apellido, @Telefono);

        COMMIT TRANSACTION;

        -- 4. Mostrar confirmación con el hash en hexadecimal puro (64 caracteres)
        SELECT 
            'Cliente registrado exitosamente.' AS Mensaje, 
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
