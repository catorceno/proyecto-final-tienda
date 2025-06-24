--probadno sp con hash 
EXEC sp_RegistrarNuevosClientes
    @Correo = 'cliente123@example.com',
    @Password = 'MiPasswordSegura123',
    @Nombre = 'Lucía',
    @Apellido = 'Reyes',
    @Telefono = 71234567;

 
