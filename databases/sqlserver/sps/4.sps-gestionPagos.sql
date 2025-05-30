USE Tienda
GO

-- 1.
CREATE PROCEDURE sp_registrarDireccion
@ClienteID INT,
@Barrio    NVARCHAR(50),
@Calle     NVARCHAR(50),
@Numero    INT 
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

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;	
	END CATCH
END;

-- 2.
CREATE PROCEDURE sp_registrarTarjeta
@ClienteID     INT,
@Red           NVARCHAR(20),
@NombreTitular NVARCHAR(50),
@Numero        BIGINT,
@CVC           INT,
@ExpDate       DATE
AS
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
		IF EXISTS (
			SELECT 1
			FROM TARJETAS 
			WHERE ClienteID = @ClienteID 
			AND Numero = @Numero
		)
		BEGIN
			THROW 50005, 'Esta tarjeta ya fue registrada.', 1;
		END
		
		INSERT INTO TARJETAS(ClienteID, Red, NombreTitular, Numero, ExpDate, CVC)
		VALUES (@ClienteID, @Red, @NombreTitular, @Numero, @ExpDate, @CVC);

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;	
	END CATCH
END;

-- 3.
CREATE PROCEDURE sp_registrarDatosFactura
@ClienteID   INT,
@RazonSocial NVARCHAR(50),
@NitCi       INT
AS
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
		IF EXISTS(
			SELECT 1
			FROM DATOS_FACTURA
			WHERE ClienteID = @ClienteID AND NitCi = @NitCi AND RazonSocial = @RazonSocial
		)
		BEGIN
			THROW 50005, 'Estos datos de factura ya existen.', 1;
		END

		INSERT INTO DATOS_FACTURA(ClienteID, RazonSocial, NitCi)
		VALUES (@ClienteID, @RazonSocial, @NitCi);

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;	
	END CATCH
END;