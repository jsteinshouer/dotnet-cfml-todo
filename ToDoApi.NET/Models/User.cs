using Microsoft.AspNetCore.Identity;

namespace ToDoApi.Models;

public class User : IdentityUser
{

    public ICollection<ToDo> ToDos { get; set; } = [];

    public bool IsAllDone() 
    {
        foreach (var item in ToDos)
        {
            if ( item.IsDone == false )
            {
                return false;
            }
        }
        
        return true;
    }
}