--3. Pruebas eliminar direccion 
-- Primero agregamos una direcci�n que no est� en uso para poder probar

--primero isnertamos un dato temporal
INSERT INTO DIRECCIONES (ClienteID, Barrio, Calle, Numero)
VALUES (2, 'Barrio Temporal', 'Calle Temporal', 111);

--buscamso el barrio por id 
SELECT DireccionID, ClienteID, Barrio, Calle, Numero
FROM DIRECCIONES
WHERE Barrio = 'Barrio Temporal' AND Calle = 'Calle Temporal' AND Numero = 111;

--luego eliminamos la direccion por el id 
EXEC sp_eliminarDireccion @DireccionID = 7;  -- Cambia el 7 por el ID correcto
select * from DIRECCIONES



--Prueba 1: Eliminar direcci�n sin compras asociadas (�xito)
-- Agregamos una direcci�n temporal que no tenga compras asociadas
--CORRECTO
INSERT INTO DIRECCIONES (ClienteID, Barrio, Calle, Numero)
VALUES (2, 'Barrio de Prueba', 'Calle de Prueba', 123);

-- Capturamos el ID reci�n insertado
DECLARE @IDDireccionSinCompras INT = SCOPE_IDENTITY();
-- Ejecutamos el procedimiento para eliminarla
EXEC usp_EliminarDireccion @DireccionID = @IDDireccionSinCompras;

--verificamos si no esicte 
select * from DIRECCIONES
select * from COMPRAS


--PRUEBA 2: ELIMINAR UNA DIRECCION QUE NO EXISTE (ERROR ESPERADO)
-- PRUEBA 2: Eliminar direcci�n que NO existe (error esperado)
--CORRECTO
BEGIN TRY
    EXEC usp_EliminarDireccion @DireccionID = 9999;
END TRY
BEGIN CATCH
    SELECT '? Error esperado (no existe):' AS Mensaje, ERROR_MESSAGE() AS Detalle;
END CATCH;


---PRUEBA 3: VERIFICACION SI TRATO DE ELIMIAR DIRECCION VINCULADO EN COMPRAS A UNA COMPRA 
--CORRECTO
--si trato de eliminar una direccion con una compra 
-- Intentar eliminar una direcci�n que s� est� en uso
BEGIN TRY
    EXEC usp_EliminarDireccion @DireccionID = 1;
END TRY
BEGIN CATCH
    SELECT 'Error:' AS Resultado, ERROR_MESSAGE() AS Mensaje;
END CATCH;




