USE Tienda
GO

--------------- TABLAS FIJAS - CATEGORIAS ---------------
-- 1.Categorias
SELECT * FROM CATEGORIAS
INSERT INTO CATEGORIAS(Nombre)
VALUES
	('Tecnologia'),
	('Ropa y accesorios'),
	('Hogar y Jardin'),
	('Electrodomesticos'),
	('Cuidado Personal y Belleza'),
	('Entretenimiento'),
	('Mascotas'),
	('Otro');
GO

-- 2.Subcategorias
SELECT * FROM SUBCATEGORIAS
INSERT INTO SUBCATEGORIAS(CategoriaID, Nombre)
VALUES
	(1, 'Celulares'),
	(1, 'Accesorios para celulares'),
	(1, 'Laptops'),
	(1, 'PC de Escritorio'),
	(1, 'Accesorios de computo'),
	(1, 'Tablets'),
	(1, 'Smartwatches'),
	(1, 'Impresoras'),
	(1, 'Televisores'),
	(1, 'Consolas'),
	(1, 'Proyectores de Video'),
	(1, 'Parlantes'),
	(1, 'Audio Personal'),
	(1, 'Otros'),

	(2, 'Bolsos y Equipaje'),
	(2, 'Joyas'),
	(2, 'Accesorios'),
	(2, 'Calzados'),
	(2, 'Trajes de Baño'),
	(2, 'Ropa para Mujer'),
	(2, 'Ropa para Hombre'),
	(2, 'Ropa para Niños'),
	(2, 'Ropa deportiva'),
	(2, 'Otros'),
	
	(3, 'Muebles'),
	(3, 'Decoracion'),
	(3, 'Jardineria'),
	(3, 'Limpieza'),
	(3, 'Herramientas'),
	(3, 'Cama y colchones'),
	(3, 'Otros'),

	(4, 'Climatizacion'),
	(4, 'Cocinas y Encimeras'),
	(4, 'Refrigeracion'),
	(4, 'Hornos y Microondas'),
	(4, 'Lavadoras y Secadoras'),
	(4, 'Extractores'),
	(4, 'Parrillas Electricas'),
	(4, 'Electrodomesticos Pequeños'),
	(4, 'Otros'),

	(5, 'Cuidado Corporal'),
	(5, 'Cuidado de la Piel'),
	(5, 'Maquillaje'),
	(5, 'Planchas'),
	(5, 'Cuidado Capilar'),
	(5, 'Peines y Cepillos'),
	(5, 'Secadoras de cabello'),
	(5, 'Rasuradoras y Cortadoras de cabello'),
	(5, 'Otros'),

	(6, 'Juguetes'),
	(6, 'Juegos'),
	(6, 'Videojuegos'),
	(6, 'Peliculas'),
	(6, 'Libros'),
	(6, 'Artes y manualidades'),
	(6, 'Otros'),

	(7, 'Juguetes'),
	(7, 'Alimento'),
	(7, 'Higiene'),
	(7, 'Ropa'),
	(7, 'Otros articulos'),

	(8, 'Suministros de oficina'),
	(8, 'Decoracion de eventos'),
	(8, 'Equipamiento Medico'),
	(8, 'Otros');
GO
