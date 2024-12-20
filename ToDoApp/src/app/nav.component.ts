import { Component, inject } from '@angular/core';
import { FormsModule } from '@angular/forms'
import { RouterLink, RouterLinkActive, Router } from '@angular/router';
import { AuthService } from './auth.service';
import { NgIf } from '@angular/common'

@Component({
  selector: 'nav-bar',
  standalone: true,
  imports: [RouterLink, RouterLinkActive, NgIf, FormsModule],
  template: `
<nav class="navbar navbar-expand-lg bg-primary" data-bs-theme="dark">
  <div class="container-fluid">
    <a class="navbar-brand" routerLink="/" >To Do App ({{backendEngine}})</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarColor02" aria-controls="navbarColor02" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarColor02" *ngIf="authService.isLoggedIn">
      <ul class="navbar-nav me-auto">

      </ul>
    </div>
    <div class="collapse navbar-collapse justify-content-end"  id="navbarColor02" *ngIf="!authService.isLoggedIn">
      <ul class="navbar-nav nav">
        <li class="nav-item">
          <a class="nav-link active" routerLink="/login" routerLinkActive="active">Login</a>
        </li>
        <li class="nav-item">
          <a class="nav-link active" routerLink="/signup" routerLinkActive="active">Sign-up</a>
        </li>
      </ul>
    </div>
  </div>
</nav>
  `,
  styles: [],
})
export class NavComponent {
  backendEngine = "";
  authService = inject(AuthService);
  private router = inject(Router);

  async ngOnInit() {
    let response = await await fetch("/api/engine", {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${this.authService.token}`
      }
    });
    let data = await response.json();
    this.backendEngine = data.engine;
  }
}
