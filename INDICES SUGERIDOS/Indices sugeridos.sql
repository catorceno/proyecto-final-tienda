-- Archivo: indices_recomendados.sql
-- Descripción: Índices no clusterizados recomendados para mejorar el rendimiento de consultas en la base de datos "Tienda"

-- Tabla: INVENTARIO
CREATE NONCLUSTERED INDEX IX_Inventario_ProductoID ON INVENTARIO(ProductoID);
CREATE NONCLUSTERED INDEX IX_Inventario_TiendaID ON INVENTARIO(TiendaID);
CREATE NONCLUSTERED INDEX IX_Inventario_SubcategoriaID ON INVENTARIO(SubcategoriaID);

-- Tabla: VENTAS
CREATE NONCLUSTERED INDEX IX_Ventas_ProductoID ON VENTAS(ProductoID);
CREATE NONCLUSTERED INDEX IX_Ventas_CompraID ON VENTAS(CompraID);

-- Tabla: PRODUCTOS
CREATE NONCLUSTERED INDEX IX_Productos_ProductoID ON PRODUCTOS(ProductoID);

-- Tabla: COMPRAS
CREATE NONCLUSTERED INDEX IX_Compras_ClienteID ON COMPRAS(ClienteID);
CREATE NONCLUSTERED INDEX IX_Compras_DireccionID ON COMPRAS(DireccionID);

-- Tabla: PAGOS
CREATE NONCLUSTERED INDEX IX_Pagos_CompraID ON PAGOS(CompraID);
CREATE NONCLUSTERED INDEX IX_Pagos_FacturaID ON PAGOS(FacturaID);

-- Tabla: TIENDAS
CREATE NONCLUSTERED INDEX IX_Tiendas_UserID ON TIENDAS(UserID);
CREATE NONCLUSTERED INDEX IX_Tiendas_CategoriaID ON TIENDAS(CategoriaID);

-- Tabla: CLIENTES
CREATE NONCLUSTERED INDEX IX_Clientes_UserID ON CLIENTES(UserID);

-- Tabla: USERS
CREATE NONCLUSTERED INDEX IX_Users_Tipo ON USERS(Tipo);

-- Tabla: DIRECCIONES
CREATE NONCLUSTERED INDEX IX_Direcciones_ClienteID ON DIRECCIONES(ClienteID);

-- Tabla: DATOS_FACTURA
CREATE NONCLUSTERED INDEX IX_DatosFactura_ClienteID ON DATOS_FACTURA(ClienteID);

-- Fin del archivo
