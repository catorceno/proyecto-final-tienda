--ahora probamos nuestro sp 

exec sp_registrarNuevoCliente
	@Correo = 'Leandro.ejemplo@example.com',
	@Password = 'pass000',
	@Nombre = 'Leandro',
	@Apellido = 'Jaldin',
	@Telefono = 25469871;

select * from USERS
