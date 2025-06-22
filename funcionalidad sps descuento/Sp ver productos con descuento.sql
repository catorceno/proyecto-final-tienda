CREATE OR ALTER PROCEDURE sp_VerProductosConDescuento
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ProductoID,
        Nombre,
        Descripcion,
        Precio AS PrecioOriginal,
        PrecioDescuento,
        ISNULL(PrecioDescuento, Precio) AS PrecioFinal,
        Stock,
        Estado,
        ModifiedDate
    FROM INVENTARIO
    ORDER BY ProductoID;
END;
GO
