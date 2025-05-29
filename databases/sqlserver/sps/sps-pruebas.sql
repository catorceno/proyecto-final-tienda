USE Marketplace
GO

-- sp:
EXEC sp_procesoVenta 
  @ClienteID      = 1, 
  @DireccionID    = 1, 
  @Subtotal       = 100.00, 
  @ServiceFee     = 5.00, 
  @Total          = 105.00, 
  @ProductoID     = 2, 
  @Cantidad       = 1, 
  @PrecioUnitario = 100.00;
