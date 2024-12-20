import { Injectable, inject } from '@angular/core';
import { ToDo } from './todo';
import { AuthService } from '../app/auth.service';

@Injectable({
  providedIn: 'root'
})
export class ToDoService {
  authService: AuthService = inject(AuthService);

  constructor() {
  }

  async getAll(): Promise<ToDo[]> {
    const response = await fetch("/api/todo", {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${this.authService.token}`
      }
    });
    return (await response.json()) ?? [];
  }


  async getToDo(id: number | null): Promise<ToDo> {
    const response = await fetch(`/api/todo/${id}`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${this.authService.token}`
      }
    });

    return (await response.json());
  }

  async createToDo(todo: ToDo): Promise<void> {
    const response = await fetch("/api/todo", {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${this.authService.token}`
      },
      body: JSON.stringify({
        "title": todo.title
      })
    });

  }

  async updateToDo(todo: ToDo): Promise<Boolean> {
    const response = await fetch(`/api/todo/${todo.id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${this.authService.token}`
      },
      body: JSON.stringify({
        "title": todo.title,
        "isDone": todo.isDone
      })
    });
    return (response.status == 204);
  }
  async deleteToDo(todo: ToDo): Promise<Boolean> {
    const response = await fetch(`/api/todo/${todo.id}`, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${this.authService.token}`
      }
    });
    return (response.status == 204);
  }


}
