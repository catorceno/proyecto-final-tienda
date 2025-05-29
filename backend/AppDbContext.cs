using backend.Entidades;
using Microsoft.EntityFrameworkCore;

namespace backend
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions options) : base(options)
        {
        }

        // protected AppDbContext(){}
        public DbSet<Cliente> Clientes { get; set; } // una entidad basada en la clase cliente, crear una tabla a partir de las propiedades que tenemos en la clase Cliente

    }
}