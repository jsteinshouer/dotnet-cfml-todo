using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;
using ToDoApi.Models;

namespace ToDoApi.Data;

public class ApplicationDBContext : IdentityDbContext<User>
{
    public ApplicationDBContext(DbContextOptions options)
        : base(options)
    {
    }

    public DbSet<ToDo> ToDos => Set<ToDo>();
}