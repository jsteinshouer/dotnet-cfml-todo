using System.ComponentModel.DataAnnotations;

namespace ToDoApi.Models;

public class ToDo
{
    public int Id { get; set; }

    [Required]
    [MaxLength(150)]
    public string? Title { get; set; }

    public Boolean IsDone { get; set; } = false;

    public string? UserId { get; set; }
}