--4. Pruebas de sp direcciones 
--1. vizualizar todas las direcciones 

EXEC usp_VisualizarDirecciones;

--2. mostrar direcciones de un cliente especifico que exista 
EXEC usp_VisualizarDirecciones @ClienteID = 2;

--3. vizualizar direccion de un coiente que no existe 
BEGIN TRY
    EXEC usp_VisualizarDirecciones @ClienteID = 9999;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS Error;
END CATCH;
