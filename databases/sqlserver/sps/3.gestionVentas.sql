USE Marketplace
GO

-- 1.
CREATE PROCEDURE sp_procesoVenta
@ClienteID      INT,
@DireccionID    INT,
@Subtotal       DECIMAL(20,2),
@ServiceFee     DECIMAL(4,2),
@Total          DECIMAL(20,2),
@ProductoID     INT,
@Cantidad       INT,
@PrecioUnitario DECIMAL(20,2)
AS
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO COMPRAS(ClienteID, DireccionID, Subtotal, ServiceFee, Total)
		VALUES (@ClienteID, @DireccionID, @Subtotal, @ServiceFee, @Total);
		
		DECLARE @CompraID INT = SCOPE_IDENTITY();
		INSERT INTO VENTAS(CompraID, ProductoID, Cantidad, PrecioUnitario)
		VALUES (@CompraID, @ProductoID, @Cantidad, @PrecioUnitario);

		-- bucle for de acuerdo a la @Cantidad para hacer inserts en DETALLE_VENTA, debe tomar los ItemID m�s viejos(los primeros)

	COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
	END CATCH
END;


/*
sp: sp_ (entradas desde el backend:
- ClienteID
- DireccionID
- Subtota
- ServiceFee
- Total
- ProductoID
- Cantidad
- PrecioUnitario
- OrderDate
- ShipDate)
*/