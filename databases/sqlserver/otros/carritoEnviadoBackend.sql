USE Tienda
GO 

-- funciona con MetodoPago = Tarjeta
ALTER PROCEDURE sp_realizarPedido
	@CarritoID INT,
	@DireccionID INT,
	@ClienteTarjetaID INT,
	@ClienteFacturaID INT,
	@MetodoPago NVARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
		IF EXISTS (SELECT 1 FROM PEDIDOS WHERE CarritoID = @CarritoID)
		BEGIN
            THROW 50001, 'El pedido de este carrito ya se ha realizado', 1;
        END

		DECLARE @Monto DECIMAL(20,2);
			SELECT @Monto = Total
			FROM CARRITOS
			WHERE CarritoID = @CarritoID
		
		-- IF @Monto IS NULL
        --    THROW 50002, 'No existe el carrito especificado.', 1;
		UPDATE CARRITOS
		SET Estado = 'Pagado'
		WHERE CarritoID = @CarritoID

		INSERT INTO PEDIDOS(CarritoID, DireccionID)
		VALUES (@CarritoID, @DireccionID)

		DECLARE @PedidoID INT = SCOPE_IDENTITY();

		INSERT INTO PAGOS(PedidoID, ClienteTarjetaID, ClienteFacturaID, MetodoPago, Monto)
		VALUES (@PedidoID, @ClienteTarjetaID, @ClienteFacturaID, @MetodoPago, @Monto)

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;
	END CATCH
END;