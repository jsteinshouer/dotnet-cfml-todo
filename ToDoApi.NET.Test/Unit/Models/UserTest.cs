using ToDoApi.Models;

namespace ToDoApi.Test;

public class UserTest
{
    [Fact]
    public void TestHasThingsToDo_HasOneItem()
    {
        //Arange
        var user = new User()
        {
            Email = "me@example.com",
            ToDos = [
                new ToDo() {
                    Title = "Mow the lawn",
                    IsDone = true
                },
                new ToDo() {
                    Title = "Do the dishes",
                    IsDone = false
                }
            ]
        };

        var result = user.IsAllDone();

        Assert.Equal(false, result );
    }

    [Fact]
    public void TestHasThingsToDo_EverythingDone()
    {
        //Arange
        var user = new User()
        {
            Email = "me@example.com",
            ToDos = [
                new ToDo() {
                    Title = "Mow the lawn",
                    IsDone = true
                },
                new ToDo() {
                    Title = "Do the dishes",
                    IsDone = true
                }
            ]
        };

        var result = user.IsAllDone();

        Assert.True(result);
    }

    [Fact]
    public void TestHasThingsToDo_NoTodos()
    {
        //Arange
        var user = new User()
        {
            Email = "me@example.com",
            ToDos = []
        };

        var result = user.IsAllDone();

        Assert.Equal(true, result);
    }
}