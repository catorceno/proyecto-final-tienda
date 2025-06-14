-- Prueba 1: Editar dirección existente (éxito)
--CORRECTO
EXEC sp_editarDireccion 
    @DireccionID = 1,
    @Barrio = 'Barrio Centro Actualizado',
    @Calle = 'Av. Principal Actualizado',
    @Numero = 124;
    
SELECT 'Dirección después de editar:';
SELECT * FROM DIRECCIONES WHERE DireccionID = 1;
GO

-- Prueba 2: Intentar editar dirección que no existe (error)
--CORRECTO
BEGIN TRY
    EXEC sp_editarDireccion 
        @DireccionID = 999,
        @Barrio = 'Barrio',
        @Calle = 'Calle',
        @Numero = 123;
END TRY
BEGIN CATCH
    SELECT 'Error:', ERROR_MESSAGE();
END CATCH
GO
select * from DIRECCIONES

-- Prueba 3: Intentar crear duplicado al editar (error) -----------no meneja bien el error
--INCORRECTO
--NO ESTA MANEJANDO BIEN EL ERROR CUANDO SE CREA UN DUPLICADO  -- PREGUNTAR DUDA 
BEGIN TRY
    EXEC sp_editarDireccion 
        @DireccionID = 2,
        @Barrio = 'Barrio Sur',
        @Calle = 'Av. del Sur',
        @Numero = 789;
END TRY
BEGIN CATCH
    SELECT 'Error:', ERROR_MESSAGE();
END CATCH
GO