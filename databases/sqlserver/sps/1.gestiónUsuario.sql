USE Marketplace
GO

--------------- GESTION DE USUARIOS ---------------
-- 1.Registrar Nuevo Cliente
CREATE PROCEDURE sp_registrarNuevoCliente
@Correo   NVARCHAR(100),
@Password NVARCHAR(200),
@Nombre   NVARCHAR(50),
@Apellido NVARCHAR(50),
@Telefono INT
AS
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
	IF EXISTS(
		SELECT 1
		FROM USERS 
		WHERE Correo = @Correo AND Tipo = 'Cliente'
	)
	BEGIN
		THROW 50001, 'Ya tienes una cuenta registrada.', 1;
	END
		INSERT INTO USERS(Correo, Password, Tipo)
		VALUES (@Correo, @Password, 'Cliente');

		DECLARE @UserID INT = SCOPE_IDENTITY();
		INSERT INTO CLIENTES(UserID, Nombre, Apellido, Telefono)
		VALUES (@UserID, @Nombre, @Apellido, @Telefono);
	COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;	
	END CATCH
END;

-- 2.Registrar Nueva Tienda
CREATE PROCEDURE sp_registrarNuevaTienda
@Correo   NVARCHAR(100),
@Password NVARCHAR(200),
@Nombre   NVARCHAR(50),
@NombreJuridico NVARCHAR(50),
@NIT      INT,
@Telefono INT,
@CategoriaID INT
AS
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
	IF EXISTS(
		SELECT 1
		FROM USERS 
		WHERE Correo = @Correo AND Tipo = 'Tienda'
	)
	BEGIN
		THROW 50002, 'Ya tienes una cuenta registrada.', 1;
	END
		INSERT INTO USERS(Correo, Password, Tipo)
		VALUES (@Correo, @Password, 'Tienda');

		DECLARE @UserID INT = SCOPE_IDENTITY();
		INSERT INTO TIENDAS(UserID, Nombre, NombreJuridico, NIT, Telefono, CategoriaID)
		VALUES (@UserID, @Nombre, @NombreJuridico, @NIT, @Telefono, @CategoriaID);
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;	
	END CATCH
END;

-- 3.Inicio Sesión
CREATE PROCEDURE sp_inicioSesion
@Correo   NVARCHAR(100),
@Password NVARCHAR(200)
AS
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
		IF NOT EXISTS(
			SELECT 1
			FROM USERS 
			WHERE Correo = @Correo
		)
		BEGIN
			THROW 50003, 'No tienes una cuenta registrada.', 1;
		END
		ELSE
		BEGIN
			PRINT 'Inicio sesión exitoso.';
		END
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;	
	END CATCH
END;