using Microsoft.AspNetCore.Mvc;
using ToDoApi.Data;
using ToDoApi.Models;
using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Authorization;

namespace ToDoApi.Controllers;


[Route("api/todo")]
[ApiController]
[Authorize]
public class ToDoController : Controller
{
    public ToDoController()
    {

    }

    [HttpGet]
    public async Task<ActionResult> Index(ApplicationDBContext db)
    {
        var userEntity = await db.Users
                        .Include(p => p.ToDos)
                        .AsNoTracking()
                        .SingleOrDefaultAsync(p => p.UserName == User.Identity.Name);
        return Ok(userEntity?.ToDos != null ? userEntity.ToDos : []);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult> GetTodo(ApplicationDBContext db, int id)
    {
        var todo = await db.ToDos.FirstOrDefaultAsync(td => td.UserId == User.FindFirstValue(ClaimTypes.NameIdentifier) && td.Id == id);

        if (todo is null)
            return NotFound();

        return Ok(todo);
    }

    [HttpPost]
    public async Task<ActionResult> CreateTodo(ApplicationDBContext db, ToDo todo)
    {
        todo.UserId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        db.ToDos.Add(todo);
        await db.SaveChangesAsync();
        return Created();
    }

    [HttpPut("{id}")]
    public async Task<ActionResult> UpdateTodo(ApplicationDBContext db, ToDo updateTodo, int id)
    {
        var todo = await db.ToDos.SingleOrDefaultAsync(p => p.UserId == User.FindFirstValue(ClaimTypes.NameIdentifier) && p.Id == id);
        if (todo is null)
            return NotFound();
        todo.Title = updateTodo.Title;
        todo.IsDone = updateTodo.IsDone;
        db.SaveChanges();

        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<ActionResult> DeleteTodo(ApplicationDBContext db, int id)
    {
        var todo = await db.ToDos.SingleOrDefaultAsync(p => p.Id == id);
        if (todo is null)
            return NotFound();
        db.ToDos.Remove(todo);
        await db.SaveChangesAsync();

        return NoContent();
    }

}