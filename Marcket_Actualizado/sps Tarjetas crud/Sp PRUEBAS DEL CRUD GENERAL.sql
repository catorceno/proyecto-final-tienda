--Estas son las preubas del crud de tarjetas 
USE Marketplace;
GO

select * from TARJETAS

-- Prueba 1: Registrar una nueva tarjeta para ClienteID 1
EXEC usp_RegistrarTarjeta 
    @ClienteID = 1, 
    @Red = 'Visa', 
    @NombreTitular = 'Juan P�rez', 
    @Numero = 4222222222222222, 
    @CVC = 456, 
    @ExpDate = '2027-01-01';
-- Resultado esperado: Inserta TarjetaID 6 y muestra mensaje de �xito
SELECT * FROM TARJETAS WHERE ClienteID = 1;

-- Prueba 2: Intentar registrar una tarjeta duplicada
EXEC usp_RegistrarTarjeta 
    @ClienteID = 1, 
    @Red = 'Visa', 
    @NombreTitular = 'Juan P�rez', 
    @Numero = 4111111111111111, 
    @CVC = 123, 
    @ExpDate = '2026-12-01';
-- Resultado esperado: Error 50007 (Tarjeta ya registrada)

-- Prueba 3: Visualizar tarjetas de ClienteID 1
EXEC usp_VisualizarTarjetas @ClienteID = 1;
-- Resultado esperado: Muestra TarjetaID 1 y 6 (ultimos 4 d�gitos: 1111 y 2222)

-- Prueba 4: Editar TarjetaID 6
EXEC usp_EditarTarjeta 
    @TarjetaID = 6, 
    @Red = 'MasterCard', 
    @NombreTitular = 'Juan P�rez Actualizado', 
    @Numero = 4333333333333333, 
    @CVC = 789, 
    @ExpDate = '2027-02-01';
-- Resultado esperado: Actualiza TarjetaID 6 y muestra mensaje de �xito
SELECT * FROM TARJETAS WHERE TarjetaID = 6;

-- Prueba 5: Intentar editar una tarjeta inactiva
EXEC usp_EliminarTarjeta @TarjetaID = 6;
EXEC usp_EditarTarjeta 
    @TarjetaID = 6, 
    @Red = 'Visa', 
    @NombreTitular = 'Juan P�rez', 
    @Numero = 4444444444444444, 
    @CVC = 321, 
    @ExpDate = '2027-03-01';
-- Resultado esperado: Error 50002 (Tarjeta inactiva)

-- Prueba 6: Eliminar (marcar como inactiva) TarjetaID 6
EXEC usp_EliminarTarjeta @TarjetaID = 6;
-- Resultado esperado: Marca TarjetaID 6 como 'Inactivo'
EXEC usp_VisualizarTarjetas @ClienteID = 1; -- Deber�a mostrar solo TarjetaID 1
SELECT * FROM TARJETAS WHERE TarjetaID = 6; -- Deber�a mostrar Estado = 'Inactivo'

-- Prueba 7: Intentar eliminar una tarjeta inexistente
EXEC usp_EliminarTarjeta @TarjetaID = 999;
-- Resultado esperado: Error 50001 (Tarjeta no existe)

-- Prueba 8: Intentar registrar con ClienteID inv�lido
EXEC usp_RegistrarTarjeta 
    @ClienteID = 999, 
    @Red = 'Visa', 
    @NombreTitular = 'Prueba', 
    @Numero = 4555555555555555, 
    @CVC = 654, 
    @ExpDate = '2027-04-01';
-- Resultado esperado: Error 50001 (ClienteID no existe)
GO