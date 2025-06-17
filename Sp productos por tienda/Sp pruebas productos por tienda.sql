--estas son las pruebas del sp que muestra los productos por tienda 
USE Marcket_Actualizado;
GO
select * from TIENDAS
SELECT * from INVENTARIO

insert into INVENTARIO (TiendaID, SubcategoriaID, DescuentoID, Nombre, Precio, Descripcion, PrecioDescuento, Stock, Estado)
values
	(4 , 1, 10 ,'Smartwach Pro', 200.00, 'Reloj inteligente', 170 , 15, 'Disponible'),
	(4, 3, 10 ,'Laptop Gaming', 1500.00, 'Computadora inteligente',1350.00 , 5, 'Disponible');

-- Insertar productos para TiendaID 4 (Gadgets Pro)
INSERT INTO INVENTARIO (TiendaID, SubcategoriaID, Nombre, Precio, Stock, Estado)
VALUES 
    (4, 1, 'Smartwatch Pro', 200.00, 15, 'Disponible'),
    (4, 3, 'Laptop Gaming', 1500.00, 5, 'Disponible');

-- Insertar productos para TiendaID 5 (Estilo Único)
INSERT INTO INVENTARIO (TiendaID, SubcategoriaID, Nombre, Precio, Stock, Estado)
VALUES 
    (5, 4, 'Zapatillas Running Elite', 80.00, 20, 'Disponible'),
    (5, 20, 'Camisa Casual', 40.00, 30, 'Disponible');

-- Prueba 1: Ver productos en TiendaID 1 (Tienda Electrónica)
EXEC usp_VerProductosPorTienda @TiendaID = 1;
-- Resultado esperado: Muestra "Smartphone X", "Funda Celular", "Laptop Pro 15"

-- Prueba 2: Ver productos en TiendaID 2 (Tienda de Ropa)
EXEC usp_VerProductosPorTienda @TiendaID = 2;
-- Resultado esperado: Muestra "Zapatillas Running", "Blusa Elegante"

-- Prueba 3: Ver productos en TiendaID 3 (Hogar Feliz)
EXEC usp_VerProductosPorTienda @TiendaID = 3;
-- Resultado esperado: Muestra "Sofá 3 Cuerpos", "Lámpara de Techo"

-- Prueba 4: Ver productos en TiendaID 4 (Gadgets Pro)
EXEC usp_VerProductosPorTienda @TiendaID = 4;
-- Resultado esperado: Muestra "No se encontraron productos disponibles en esta tienda."

-- Prueba 5: Ver productos en TiendaID 5 (Estilo Único)
EXEC usp_VerProductosPorTienda @TiendaID = 5;
-- Resultado esperado: Muestra "No se encontraron productos disponibles en esta tienda."

-- Prueba 6: Ver productos en TiendaID inválido
EXEC usp_VerProductosPorTienda @TiendaID = 999;
-- Resultado esperado: Error 50001 (La tienda especificada no existe.)
GO