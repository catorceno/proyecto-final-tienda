USE Tienda
GO


-- 1. ya no es necesario, quizás para el backend
CREATE TRIGGER trg_
ON VENTAS
INSTEAD OF INSERT
AS BEGIN
	INSERT INTO VENTAS(CompraID, ProductoID, Cantidad, PrecioUnitario, OrderDate, ShipDate)
	SELECT
		i.CompraID, i.ProductoID, i.Cantidad,
		COALESCE(inv.PrecioDescuento, inv.Precio),
		i.OrderDate,
		i.ShipDate
	FROM inserted i
	INNER JOIN INVENTARIO inv ON i.ProductoID = inv.ProductoID
END;

-- si sirve
CREATE TRIGGER trg_insertItemAlCarrito
ON ITEMS_CARRITO
INSTEAD OF INSERT
AS
BEGIN
	IF EXISTS (
		SELECT 1
		FROM inserted i
		INNER JOIN INVENTARIO inv ON i.ProductoID = inv.ProductoID
		WHERE i.Cantidad > inv.Stock
	)
	BEGIN
        RAISERROR('La cantidad solicitada supera el stock disponible.', 16, 1)
        ROLLBACK;
		RETURN;
	END
	INSERT INTO ITEMS_CARRITO(CarritoID, ProductoID, Cantidad, PrecioUnitario)
	SELECT
		i.CarritoID,
		i.ProductoID,
		i.Cantidad,
		CASE WHEN inv.DescuentoID IS NOT NULL THEN inv.PrecioDescuento ELSE inv.Precio END --COALESCE(inv.PrecioDescuento, inv.Precio)
	FROM inserted i
	INNER JOIN INVENTARIO inv ON inv.ProductoID = i.ProductoID

	UPDATE car
	SET 
		Subtotal = sumIC.Subtotal,
		Total = sumIC.Subtotal + car.ServiceFee
	FROM CARRITOS car
	INNER JOIN (
		SELECT CarritoID, SUM(PrecioUnitario*Cantidad) as Subtotal
		FROM ITEMS_CARRITO 
		GROUP BY CarritoID 
	) sumIC ON sumIC.CarritoID = car.CarritoID
	WHERE car.CarritoID IN (SELECT DISTINCT CarritoID FROM inserted);
END;

-- si sirve
CREATE TRIGGER trg_updateItemDelCarrito
ON ITEMS_CARRITO
INSTEAD OF UPDATE
AS
BEGIN
	IF EXISTS (
		SELECT 1
		FROM inserted i
		INNER JOIN INVENTARIO inv ON i.ProductoID = inv.ProductoID
		WHERE i.Cantidad > inv.Stock
	)
	BEGIN
        RAISERROR('La cantidad solicitada supera el stock disponible.', 16, 1)
        ROLLBACK;
		RETURN;
	END

	DELETE ic
	FROM ITEMS_CARRITO ic
	INNER JOIN inserted i ON ic.ItemCarritoID = i.ItemCarritoID
	WHERE i.Cantidad = 0;

	UPDATE ic
	SET
		ic.Cantidad = i.Cantidad,
		ic.PrecioUnitario = CASE WHEN inv.DescuentoID IS NOT NULL THEN inv.PrecioDescuento ELSE inv.Precio END
	FROM ITEMS_CARRITO ic
	INNER JOIN inserted i ON ic.ItemCarritoID = i.ItemCarritoID
	INNER JOIN INVENTARIO inv ON i.ProductoID = inv.ProductoID
	WHERE i.Cantidad > 0

	UPDATE car
	SET 
		Subtotal = sumIC.Subtotal,
		Total = sumIC.Subtotal + car.ServiceFee
	FROM CARRITOS car
	INNER JOIN (
		SELECT CarritoID, SUM(PrecioUnitario * Cantidad) as Subtotal
		FROM ITEMS_CARRITO 
		GROUP BY CarritoID 
	) sumIC ON sumIC.CarritoID = car.CarritoID
	WHERE car.CarritoID IN (SELECT DISTINCT CarritoID FROM inserted);
END;

-- si sirve
CREATE TRIGGER trg_deleteItemDelCarrito
ON ITEMS_CARRITO
AFTER DELETE
AS
BEGIN

	IF NOT EXISTS (
		SELECT 1
		FROM ITEMS_CARRITO ic
		INNER JOIN deleted d ON ic.CarritoID = d.CarritoID
		)
	BEGIN
		DELETE c FROM CARRITOS c
		INNER JOIN deleted d ON c.CarritoID = d.CarritoID;
	END
	ELSE
	BEGIN
		UPDATE car
		SET 
			Subtotal = sumIC.Subtotal,
			Total = sumIC.Subtotal + car.ServiceFee
		FROM CARRITOS car
		INNER JOIN (
			SELECT CarritoID, SUM(PrecioUnitario * Cantidad) as Subtotal
			FROM ITEMS_CARRITO 
			GROUP BY CarritoID 
		) sumIC ON sumIC.CarritoID = car.CarritoID
		-- WHERE car.CarritoID IN (SELECT DISTINCT CarritoID FROM inserted);
	END
END;