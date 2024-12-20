import { Component, inject } from '@angular/core';
import { FormsModule } from '@angular/forms'
import { NgIf } from '@angular/common'
import { Router } from '@angular/router';
import { AuthService } from './auth.service';

@Component({
  imports: [FormsModule, NgIf],
  selector: 'signin-view',
  template: `
<div class="container" style="margin-top: 30px">
  <form class="form-signin" role="form" method="post">
		<h2>Sign-In</h2>

    <div class="mb-3">
		  <input type="text" name="email" class="form-control form-control-lg" placeholder="Email" required="" autofocus="" [(ngModel)]="email">
    </div>
    <div class="mb-3">
        <input type="password" name="password" class="form-control form-control-lg" placeholder="Password" required="" [(ngModel)]="password">
    </div>
      <div class="mb-3" >
        <p class="text-danger" *ngIf="error">Login failed!</p>
    </div>

		<button class="btn btn-lg btn-primary btn-block" (click)="login()" >Login</button>
  </form>
  </div>
  `,
  styles: `
    .form-signin {
        max-width: 400px;
        padding: 15px;
        margin: 0 auto;
    }
  `,
  standalone: true,
})

export class SigninForm {
  private authService: AuthService = inject(AuthService);
  private router: Router = inject(Router);
  email="";
  password="";
  error=false;


  login() {
    this.authService.login(this.email, this.password).then((result) => {
      if (result) {
        this.router.navigateByUrl("/");
      }
      else {
        this.error = true;
      }
    });
  }

}
