using backend.Entidades;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{
    [ApiController]
    [Route("api/clientes")]
    public class ClientesController : ControllerBase
    {
        private readonly AppDbContext _context;
        public ClientesController(AppDbContext context) //para poder usar entityframeworkcore aquí
        {
            _context = context;
        }

        //creando endpoints
        [HttpGet]
        public async Task<List<Cliente>> Get()
        {
            return await _context.Clientes.ToListAsync();
        }
        [HttpGet("{id:int}", Name = "GetClientById")] // a través de la url quiero mandar el id del cliente para poder traerla !IMPORTANTE no debe haber espacio, por ejemplo así no: id: int
        public async Task<ActionResult<Cliente>> Get(int id)
        {
            var cliente = await _context.Clientes.FirstOrDefaultAsync(x => x.ClienteID == id); // trae el primer cliente que apareza con el id correspondiente, y si no hay pues devuelve nulo
            if (cliente is null)
            {
                return NotFound();
            }
            return cliente;
        }
        [HttpPost]
        public async Task<CreatedAtRouteResult> Post(Cliente cliente)
        {
            _context.Add(cliente); // este Add() es de memoria, no de la db, por eso no es async, solo se esta marcando que va a ser insertado en el futuro
            await _context.SaveChangesAsync();
            return CreatedAtRoute("GetClientById", new { id = cliente.ClienteID }, cliente); // cuando se inserte el registro en la bd automaticamente se le coloca en la propiedad id el id correspondiente
        }
        [HttpPut("{id:int}")]
        public async Task<ActionResult> Put(int id, Cliente cliente)
        {
            var existeCliente = await _context.Clientes.AnyAsync(x => x.ClienteID == id);
            if (!existeCliente)
            {
                return NotFound();
            }
            _context.Update(cliente);
            await _context.SaveChangesAsync();
            return NoContent(); //204, no content
        }
        [HttpDelete("{id:int}")]
        public async Task<ActionResult> Delete(int id)
        {
            var deletedRows = await _context.Clientes.Where(x => x.ClienteID == id).ExecuteDeleteAsync(); // devuelve la cantidad de filas que fueron afectadas
            if (deletedRows == 0)
            {
                return NotFound();
            }
            return NoContent();
        }
    }
}