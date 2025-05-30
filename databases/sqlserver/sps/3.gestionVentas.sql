USE Tienda
GO

-- 1.

ALTER PROCEDURE sp_procesoVenta
@ClienteID      INT,
@DireccionID    INT,
@FacturaID      INT,
@MetodoPago     NVARCHAR(20),
@TarjetaID      INT,
@ProductoID     INT,
@Cantidad       INT,
@PrecioUnitario DECIMAL(20,2),
@Subtotal       DECIMAL(20,2),
@ServiceFee     DECIMAL(4,2),
@Total          DECIMAL(20,2)
AS
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO COMPRAS(ClienteID, DireccionID, Subtotal, ServiceFee, Total)
		VALUES (@ClienteID, @DireccionID, @Subtotal, @ServiceFee, @Total);
		
		DECLARE @CompraID INT = SCOPE_IDENTITY();

		INSERT INTO PAGOS(CompraID, FacturaID, TarjetaID, MetodoPago, Monto)
		VALUES (@CompraID, @FacturaID, @TarjetaID, @MetodoPago, @Total);

		INSERT INTO VENTAS(CompraID, ProductoID, Cantidad, PrecioUnitario)
		VALUES (@CompraID, @ProductoID, @Cantidad, @PrecioUnitario);

		DECLARE @VentaID INT = SCOPE_IDENTITY();

        DECLARE @Contador INT = 1;
        DECLARE @ItemID INT;

        WHILE @Contador <= @Cantidad
        BEGIN
            SELECT TOP 1
                @ItemID = ItemID
            FROM PRODUCTOS WITH (UPDLOCK, READPAST) -- para evitar deadlocks
            WHERE ProductoID = @ProductoID
              AND Estado = 'Disponible'
            ORDER BY ItemID ASC;

            INSERT INTO DETALLE_VENTA(VentaID, ItemID)
            VALUES (@VentaID, @ItemID);

            SET @Contador += 1;
        END

	COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
	END CATCH
END;

-- para varios productos diferentes
-- En tu base de datos Tienda:
CREATE TYPE dbo.TablaItems AS TABLE
(
    ProductoID      INT         NOT NULL,
    Cantidad        INT         NOT NULL,
    PrecioUnitario  DECIMAL(20,2) NOT NULL
);
GO
CREATE PROCEDURE usp_procesoVenta
@ClienteID      INT,
@DireccionID    INT,
@FacturaID      INT,
@MetodoPago     NVARCHAR(20),
@TarjetaID      INT,
@Items          dbo.TablaItems READONLY,
@Subtotal       DECIMAL(20,2),
@ServiceFee     DECIMAL(4,2),
@Total          DECIMAL(20,2)
AS
BEGIN
    INSERT INTO COMPRAS (ClienteID, DireccionID, ServiceFee)
    VALUES (@ClienteID, @DireccionID, @ServiceFee);

    DECLARE @CompraID = SCOPE_IDENTITY();

    INSERT INTO VENTAS (CompraID, ProductoID, Cantidad, PrecioUnitario)
    SELECT 
        @CompraID,
        ProductoID,
        Cantidad,
        PrecioUnitario
    FROM @Items;

	DECLARE @VentaID INT = SCOPE_IDENTITY();

        DECLARE @Contador INT = 1;
        DECLARE @ItemID INT;

        WHILE @Contador <= @Cantidad
        BEGIN
            SELECT TOP 1
                @ItemID = ItemID
            FROM PRODUCTOS WITH (UPDLOCK, READPAST) -- para evitar deadlocks
            WHERE ProductoID = @ProductoID
              AND Estado = 'Disponible'
            ORDER BY ItemID ASC;

            INSERT INTO DETALLE_VENTA(VentaID, ItemID)
            VALUES (@VentaID, @ItemID);

            SET @Contador += 1;
        END
END

-- 2.
CREATE PROCEDURE sp_registrarNuevaDireccion
@ClienteID INT,
@Barrio NVARCHAR(50),
@Calle NVARCHAR(50),
@Numero INT
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO DIRECCIONES(Barrio, Calle, Numero)
		VALUES(@Barrio, @Calle, @Numero);
		
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
/* explicacion de updlock y readpast
2. Los lock hints WITH (UPDLOCK, READPAST)
Cuando varias transacciones concurrentes quieren leer o modificar las mismas filas, SQL Server gestiona bloqueos (“locks”) para asegurar la consistencia de los datos. Los lock hints te permiten controlar el tipo de bloqueo que usarás en una consulta concreta.

UPDLOCK
Propósito: Solicita un bloqueo de actualización (update lock) sobre las filas leídas.

Comportamiento:
Evita que otra transacción obtenga un bloqueo exclusivo (X) sobre la misma fila.
Sin embargo, a diferencia de un bloqueo de lectura compartida (S), la intención es después convertirlo en un bloqueo exclusivo para un UPDATE.

¿Por qué lo usamos?
Imagina dos usuarios ejecutando el mismo SP simultáneamente para vender unidades de un mismo producto.
Si ambos leen la misma fila “disponible” sin UPDLOCK, podrían “repartirse” esa unidad duplicadamente.
Con UPDLOCK, la primera transacción marca la fila como “en proceso de actualizar”. La segunda la verá bloqueada y esperará (o la saltará, con READPAST, que veremos a continuación).

READPAST
Propósito: Pide omitir (saltar) filas bloqueadas por otros bloqueos (por ejemplo, aquellas con UPDLOCK de otra transacción).

Comportamiento:
Si una fila está actualmente bloqueada y tu consulta lleva READPAST, esa fila se omite como si no existiera temporalmente.
Solo devuelve filas que estén libres de bloqueos incompatibles.

¿Por qué lo combinamos?
UPDLOCK asegura que una vez que hemos “apuntado” a una fila para actualizarla, nadie más pueda reservarla.
READPAST hace que cada transacción concurrente “salte” las filas ya reservadas y busque la siguiente disponible, evitando esperas o deadlocks.

Ejemplo ilustrativo
Supongamos que hay 3 ítems disponibles con ItemID 1, 2 y 3 en estado 'Disponible'. Dos transacciones A y B ejecutan casi al mismo tiempo:
Transacción A inicia, elige con SELECT TOP 1 … WITH (UPDLOCK, READPAST) el ItemID = 1 y lo bloquea.
Transacción B llega y hace el mismo SELECT TOP 1 ….
Ve que ItemID = 1 está bloqueado → lo omite por READPAST.
Entonces lee ItemID = 2 y lo bloquea con su propio UPDLOCK.
Cada transacción prosigue con su propio ítem, sin pisarse mutuamente, e inserta / actualiza de forma segura.
*/
/*
ALTER PROCEDURE sp_procesoVenta
    @ClienteID       INT,
    @DireccionID     INT,
    @Subtotal        DECIMAL(20,2),
    @ServiceFee      DECIMAL(4,2),
    @Total           DECIMAL(20,2),
    @ProductoID      INT,
    @Cantidad        INT,
    @PrecioUnitario  DECIMAL(20,2)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1) Insertamos la compra
        INSERT INTO COMPRAS(ClienteID, DireccionID, Subtotal, ServiceFee, Total)
        VALUES (@ClienteID, @DireccionID, @Subtotal, @ServiceFee, @Total);

        DECLARE @CompraID INT = SCOPE_IDENTITY();

        -- 2) Insertamos la cabecera de la venta
        INSERT INTO VENTAS(CompraID, ProductoID, Cantidad, PrecioUnitario)
        VALUES (@CompraID, @ProductoID, @Cantidad, @PrecioUnitario);

        DECLARE @VentaID INT = SCOPE_IDENTITY();

        -- 3) Por cada unidad, seleccionamos el Item más antiguo disponible
        DECLARE @Contador INT = 1;
        DECLARE @ItemID INT;

        WHILE @Contador <= @Cantidad
        BEGIN
            -- Tomamos el primer ItemID disponible para este Producto
            SELECT TOP 1
                @ItemID = ItemID
            FROM PRODUCTOS WITH (UPDLOCK, READPAST)
            WHERE ProductoID = @ProductoID
              AND Estado = 'Disponible'
            ORDER BY ItemID ASC;

            IF @ItemID IS NULL
            BEGIN
                -- No hay suficientes ítems disponibles: abortamos
                THROW 50001, 'No hay suficientes unidades disponibles para el producto.', 1;
            END

            -- 4) Insertamos en detalle de venta
            INSERT INTO DETALLE_VENTA(VentaID, ItemID)
            VALUES (@VentaID, @ItemID);

            -- 5) Marcamos el ítem como vendido
            UPDATE PRODUCTOS
            SET Estado = 'Vendido',
                ModifiedDate = GETDATE()
            WHERE ItemID = @ItemID;

            SET @Contador += 1;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;  -- re-lanzamos el error original
    END CATCH
END;
GO

*/