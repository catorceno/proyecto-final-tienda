--prueba de sp registrar direccion 
-- Prueba 1: Registrar direcci�n nueva (�xito)
DECLARE @NuevaDireccionID INT;
EXEC sp_registrarDireccion 
    @ClienteID = 1,
    @Barrio = 'Barrio Nuevo',
    @Calle = 'Calle Nueva',
    @Numero = 999,
    @NuevaDireccionID = @NuevaDireccionID OUTPUT;

DECLARE @NuevaDireccionID INT; 
SELECT 'Direcci�n registrada con ID:', @NuevaDireccionID;
SELECT * FROM DIRECCIONES WHERE DireccionID = @NuevaDireccionID;
GO

select * from DIRECCIONES


-- Prueba 2: Intentar registrar direcci�n duplicada (error)
BEGIN TRY
    EXEC sp_registrarDireccion 
        @ClienteID = 1,
        @Barrio = 'Barrio Centro',
        @Calle = 'Av. Principal',
        @Numero = 123,
        @NuevaDireccionID = NULL;
END TRY
BEGIN CATCH
    SELECT 'Error:', ERROR_MESSAGE();
END CATCH
GO