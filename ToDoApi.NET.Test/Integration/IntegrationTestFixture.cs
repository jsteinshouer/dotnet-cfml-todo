using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;
using System.Security.Claims;
using ToDoApi.Data;
using ToDoApi.Models;

namespace ToDoApi.Test;

public class IntegrationTestFixture
{
    private const string ConnectionString = "Data Source=./ToDoTest.db";

    private static readonly object _lock = new();
    private static bool _databaseInitialized;

    public User TestUser;

    public IntegrationTestFixture()
    {
        lock (_lock)
        {
            if (!_databaseInitialized)
            {
                using (var context = CreateContext())
                {
                    context.Database.EnsureDeleted();
                    context.Database.EnsureCreated();

                    var userManager = new UserManager<User>(new UserStore<User>(context), null, new PasswordHasher<User>(), null, null, null, null, null, null);
                    // var userManager = new UserManager<User>(new UserStore<User>(context), new IdentityOptions(), new PasswordHasher<User>(), new List<UserValidator<User>>(), new List<PasswordValidator<User>>(), new UpperInvariantLookupNormalizer(), new );
                    User user = new User()
                    {
                        UserName = "me@example.com",
                        Email = "me@example.com",
                    };

                    var result = userManager.CreateAsync(user, "P@ssword1");

                    this.TestUser = user;

                    context.ToDos.AddRange(
                        new ToDo { Title = "Mow the lawn", IsDone = false, UserId = user.Id },
                        new ToDo { Title = "Buy a car", IsDone = true, UserId = user.Id }
                    );
                    context.SaveChanges();
                }

                _databaseInitialized = true;
            }
        }
    }

    public ApplicationDBContext CreateContext()
        => new ApplicationDBContext(
            new DbContextOptionsBuilder<ApplicationDBContext>()
                .UseSqlite(ConnectionString)
                .Options);
    public ClaimsPrincipal CreateClaimsPrincipal()
        => new ClaimsPrincipal(new ClaimsIdentity(new Claim[] {
                    new Claim(ClaimTypes.NameIdentifier, this.TestUser.Id),
                    new Claim(ClaimTypes.Name, this.TestUser.Email)
                    // other required and custom claims
                }, "TestAuthentication"));
}