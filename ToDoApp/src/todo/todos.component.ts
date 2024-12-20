import { Component,inject } from '@angular/core';
import { NgIf, NgClass } from '@angular/common';
import { RouterLink, RouterLinkActive, ActivatedRoute } from '@angular/router';
import { FormsModule, NgModel } from '@angular/forms'
import { ToDo } from './todo';
import { ToDoService } from './todo.service';


@Component({
  selector: 'todos',
  imports: [NgIf, NgClass, FormsModule],
  template: `
    <h2>To Do</h2>

    <div class="col-sm-12 col-md-10 col-lg-8">

      <div class="input-group input-group-lg">
        <input type="email" class="form-control" id="newTodo" placeholder="To Do" [(ngModel)]="newTodo.title" (keyup.enter)="addToDo()">
        <input class="btn btn-primary" type="button" (click)="addToDo()" value="Add">
      </div>
      <ul class="list-group fs-4 mt-5">
        @for ( todo of todos; track todo.id) {
          <li class="list-group-item">
            <input class="form-check-input me-1 me-3" type="checkbox" value="" :id="'todo-' + todo.id" [(ngModel)]="todo.isDone" (ngModelChange)="saveToDo(todo)">
            <label class="form-check-label fs-4"  [ngClass]="todo.isDone ? 'todo-done' : ''" :for="'todo-' + todo.id">{{todo.title}}</label>
            <span class="float-end trash-can" (click)="deleteToDo(todo)" data-testid="trash-can">
              <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-trash" viewBox="0 0 25 25">
                <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0z"/>
                <path d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4zM2.5 3h11V2h-11z"/>
              </svg>
            </span>
          </li>
        }
      </ul>
    </div>

  `,
  styles: `
    .todo-done {
      text-decoration: line-through;
    }
    .trash-can {
      color: gray;
    }
    .trash-can:hover {
      cursor: pointer;
      color: black;
    }
  `,
  standalone: true,
})
export class ToDoList {
  todos: ToDo[] = [];
  newTodo: ToDo = new ToDo();
  private _todoService: ToDoService = inject(ToDoService);

  constructor() {

  }

  async ngOnInit() {
    this.todos = await this._todoService.getAll();
  }

  async saveToDo(todo: ToDo) {
    await this._todoService.updateToDo(todo);
  }

  async addToDo() {
    if ( this.newTodo.title != "") {

      await this._todoService.createToDo(this.newTodo);
      this.todos = await this._todoService.getAll();
      this.newTodo.title = "";
    }
  }

  async deleteToDo( todo: ToDo) {
    await this._todoService.deleteToDo(todo);
    this.todos = await this._todoService.getAll();
  }


}
