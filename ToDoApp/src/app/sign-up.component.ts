import { Component, inject } from '@angular/core';
import { FormsModule } from '@angular/forms'
import { NgIf } from '@angular/common'
import { Router } from '@angular/router';
import { AuthService } from './auth.service';

@Component({
  imports: [FormsModule, NgIf],
  selector: 'register-view',
  template: `
<div class="container" style="margin-top: 30px">
  <form class="form-register" role="form" method="post">
		<h2>Create an account!</h2>

    <div class="mb-3">
		  <input type="text" name="email" class="form-control form-control-lg" placeholder="Email" required="" autofocus="" [(ngModel)]="email">
    </div>
    <div class="mb-3">
        <input type="password" name="password" class="form-control form-control-lg" placeholder="Password" required="" [(ngModel)]="password">
    </div>
    <div class="mb-3">
        <input type="password" name="password" class="form-control form-control-lg" placeholder="Confirm Password" required="" [(ngModel)]="confirmPassword">
    </div>
    <div class="mb-3" >
        <p class="text-danger" *ngIf="error">An error occured during sing-up.</p>
    </div>

		<button class="btn btn-lg btn-primary btn-block" (click)="register()" >Signup</button>
  </form>
  </div>
  `,
  styles: `
    .form-register {
        max-width: 400px;
        padding: 15px;
        margin: 0 auto;
    }
  `,
  standalone: true,
})

export class SignupForm {
  private router: Router = inject(Router);
  private authService = inject(AuthService);

  email="";
  password="";
  confirmPassword="";
  error=false;

  register() {
    this.authService.register( this.email, this.password ).then( (result) => {
      if (result) {
        this.router.navigateByUrl("/login");
      }
      else {
        this.error = true;
      }
    });
  }

}
