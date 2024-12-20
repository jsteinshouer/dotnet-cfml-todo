using ToDoApi.Controllers;
using ToDoApi.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace ToDoApi.Test;

public class ToDoControllerTest : IClassFixture<IntegrationTestFixture>
{
    public ToDoControllerTest(IntegrationTestFixture fixture)
    => Fixture = fixture;

    public IntegrationTestFixture Fixture { get; }

    [Fact]
    public async void TestIndex()
    {
        using var context = Fixture.CreateContext();
        var controller = new ToDoController();

        controller.ControllerContext = new ControllerContext();
        controller.ControllerContext.HttpContext = new DefaultHttpContext { User = Fixture.CreateClaimsPrincipal() };


        var result = await controller.Index(context);
        var data = (result as OkObjectResult).Value as IEnumerable<ToDo>;

        Assert.Equal( 2, data.Count());
        Assert.Equal("Mow the lawn", data.FirstOrDefault().Title);

    }

    [Fact]
    public async void TestGetToDo()
    {
        using var context = Fixture.CreateContext();
        var controller = new ToDoController();

        controller.ControllerContext = new ControllerContext();
        controller.ControllerContext.HttpContext = new DefaultHttpContext { User = Fixture.CreateClaimsPrincipal() };


        var result = await controller.GetTodo(context, 1);
        var data = (result as OkObjectResult).Value as ToDo;

        Assert.Equal("Mow the lawn", data.Title);

    }

    [Fact]
    public async void TestCreateToDo()
    {
        using var context = Fixture.CreateContext();
        var controller = new ToDoController();

        controller.ControllerContext = new ControllerContext();
        controller.ControllerContext.HttpContext = new DefaultHttpContext { User = Fixture.CreateClaimsPrincipal() };

        var newToDo = new ToDo() {
            Title = "Take out the trash",
            IsDone = false,
            UserId = Fixture.TestUser.Id
        };

        //Start a transaction so we can roll back changes
        context.Database.BeginTransaction();

        var result = await controller.CreateTodo(context, newToDo);
        
        var todo = context.ToDos.SingleOrDefault(item => item.Title == newToDo.Title);

        //Rollback changes
        context.ChangeTracker.Clear();

        Assert.Equal(newToDo.Title, todo.Title);
        Assert.Equal(Fixture.TestUser.Id, todo.UserId);

    }

    [Fact]
    public async void TestUpdateToDo()
    {
        using var context = Fixture.CreateContext();
        var controller = new ToDoController();

        controller.ControllerContext = new ControllerContext();
        controller.ControllerContext.HttpContext = new DefaultHttpContext { User = Fixture.CreateClaimsPrincipal() };

        var updateTodo = context.ToDos.SingleOrDefault(item => item.Title == "Mow the lawn");

        //Start a transaction so we can roll back changes
        context.Database.BeginTransaction();

        var result = await controller.UpdateTodo(context, updateTodo, updateTodo.Id);
        

        //Rollback changes
        context.ChangeTracker.Clear();

        Assert.Equal(204, (result as NoContentResult).StatusCode);

    }

    [Fact]
    public async void TestUpdateToDo_NotFound()
    {
        using var context = Fixture.CreateContext();
        var controller = new ToDoController();

        controller.ControllerContext = new ControllerContext();
        controller.ControllerContext.HttpContext = new DefaultHttpContext { User = Fixture.CreateClaimsPrincipal() };
        //Start a transaction so we can roll back changes
        context.Database.BeginTransaction();

        var updateTodo = context.ToDos.SingleOrDefault(item => item.Title == "Mow the lawn");

        var result = await controller.UpdateTodo(context, updateTodo, 999);
        
        //Rollback changes
        context.ChangeTracker.Clear();

        Assert.Equal(404, (result as NotFoundResult).StatusCode);

    }


    [Fact]
    public async void TestDeleteToDo()
    {
        using var context = Fixture.CreateContext();
        var controller = new ToDoController();

        controller.ControllerContext = new ControllerContext();
        controller.ControllerContext.HttpContext = new DefaultHttpContext { User = Fixture.CreateClaimsPrincipal() };

        //Start a transaction so we can roll back changes
        context.Database.BeginTransaction();

        var result = await controller.DeleteTodo(context, 1);

        var todos = context.ToDos.ToList();

        //Rollback changes
        context.ChangeTracker.Clear();

        Assert.DoesNotContain(todos, item => item.Id == 1);

    }
}