USE Tienda
GO

-- 1.Aplicar un descuento a un producto
CREATE PROCEDURE sp_aplicarDescuentoAProducto
@TiendaID    INT,
@DescuentoID INT,
@ProductoID  INT
AS
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
		UPDATE INVENTARIO
		SET DescuentoID = @DescuentoID
		WHERE ProductoID = @ProductoID AND TiendaID = @TiendaID
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;	
	END CATCH
END;