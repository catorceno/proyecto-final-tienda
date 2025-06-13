USE Tienda
GO

-- 1.Aplicar un descuento a un producto
CREATE PROCEDURE sp_aplicarDescuentoAProducto
@DescuentoID INT,
@ProductoID  INT
AS
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
		UPDATE INVENTARIO
		SET DescuentoID = @DescuentoID
		WHERE ProductoID = @ProductoID
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;	
	END CATCH
END;

-- agregar estado a un producto? Disponible, Sin Stock, Descontinuado/Descartado
select * from inventario
-- 2.
-- resolver si si añade cada item o de llena de acuerdo al stock
CREATE PROCEDURE sp_registrarProducto 
@TiendaID       INT,
@SubcategoriaID INT,
@Nombre         NVARCHAR(50),
@Precio         DECIMAL(20,2),
@Descripcion    NVARCHAR(200)
-- @Stock          INT
AS
BEGIN
BEGIN TRY
	BEGIN TRANSACTION
	INSERT INTO INVENTARIO(TiendaID, SubcategoriaID, Nombre, Precio, Descripcion)
	VALUES (@TiendaID, @SubcategoriaID, @Nombre, @Precio, @Descripcion);

	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;	
END CATCH
END;

select * from inventario
-- 3.
-- resolver si se va poder editar la cantidad de Stock
CREATE PROCEDURE sp_editarProducto
@ProductoID     INT,
@SubcategoriaID INT,
@Nombre         NVARCHAR(50),
@Precio         DECIMAL(20,2),
@Descripcion    NVARCHAR(200),
@DescuentoID    INT
AS
BEGIN
BEGIN TRY
	BEGIN TRANSACTION
	UPDATE INVENTARIO
	SET
		SubcategoriaID = @SubcategoriaID,
		Nombre = @Nombre,
		Precio = @Precio,
		Descripcion = @Descripcion,
		DescuentoID = @DescuentoID
	WHERE ProductoID = @ProductoID

	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;	
END CATCH
END;

select * from inventario
-- 4.
CREATE PROCEDURE sp_eliminarProducto -- pasar a descartado
@TiendaID   INT,
@ProductoID INT
AS
BEGIN
BEGIN TRY
	BEGIN TRANSACTION
	IF EXISTS (
		select 1 from productos
		where productoID = @ProductoID AND Estado = 'Disponible'
	)
	UPDATE INVENTARIO 
	SET Estado = 'Descontinuado'
	WHERE ProductoID = @ProductoID

	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;	
END CATCH
END;

-- 5.
CREATE PROCEDURE sp_verInventario -- mostrar por secciones de acuerdo al estado 
@TiendaID INT
AS BEGIN
	SELECT
        i.Stock,
        i.Nombre            AS Producto,
        c.Nombre            AS Categoria, -- quitar quizas
        s.Nombre            AS Subcategoria, -- quitar quizas
        i.Precio,
        d.Nombre            AS NombreDescuento,
        d.Porcentaje        AS PorcentajeDescuento,
        i.PrecioDescuento
    FROM INVENTARIO i
    INNER JOIN SUBCATEGORIAS s ON i.SubcategoriaID = s.SubcategoriaID
    INNER JOIN CATEGORIAS c ON s.CategoriaID = c.CategoriaID
    LEFT JOIN DESCUENTOS d ON i.DescuentoID = d.DescuentoID
    WHERE i.TiendaID = @TiendaID
    ORDER BY i.Nombre ASC;
END;