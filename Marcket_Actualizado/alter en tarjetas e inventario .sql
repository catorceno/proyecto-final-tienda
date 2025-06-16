--haremos las actualizaciones en las tablas de tarjetas e inventario
--Modifiacremos la tabla tarjetas 
USE Marcket_Actualizado

ALTER TABLE TARJETAS 
ADD Estado NVARCHAR(20) NOT NULL DEFAULT 'Activo'
CONSTRAINT chk_EstadoTarjetas CHECK (Estado in('Activo', 'Inactivo'));

--Actualizamos los registrs existentes de tarjetas a activo 
UPDATE TARJETAS 
SET Estado = 'Activo';

select * from TARJETAS


--Modificaremos el Inventario
ALTER TABLE INVENTARIO 
ADD CONSTRAINT chk_EstadoIventario CHECK (Estado in('Disponible', 'Descontinuado'));


--actualizamos los resgistros disponibeles del inventario 
UPDATE INVENTARIO
SET Estado = 'Disponible'
WHERE Estado = 'Disponible'; --refuerza la consistencia 

select * from INVENTARIO
