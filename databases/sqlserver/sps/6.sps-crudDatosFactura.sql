USE Tienda
GO

-- 1.
CREATE PROCEDURE sp_registrarDatosFactura
@ClienteID   INT,
@RazonSocial NVARCHAR(50),
@NitCi       INT
AS
BEGIN
BEGIN TRY
	BEGIN TRANSACTION
	IF EXISTS( -- evitar duplicados
		select 1 from DATOS_FACTURA
		where ClienteID = @ClienteID AND RazonSocial = @RazonSocial AND NitCi = @NitCi
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

-- 2.
CREATE PROCEDURE sp_editarDatosFactura
@FacturaID   INT,
@RazonSocial NVARCHAR(50),
@NitCi       INT
AS
BEGIN
BEGIN TRY
	BEGIN TRANSACTION
	IF EXISTS( -- evitar duplicados
		select 1 from DATOS_FACTURA
		where FacturaID <> @FacturaID AND RazonSocial = @RazonSocial AND NitCi = @NitCi
	)
	BEGIN
		THROW 50005, 'Estos datos de factura ya existen.', 1;
	END

	UPDATE DATOS_FACTURA
	SET RazonSocial = @RazonSocial, NitCi = @NitCi
	WHERE FacturaID = @FacturaID 

	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;	
END CATCH
END