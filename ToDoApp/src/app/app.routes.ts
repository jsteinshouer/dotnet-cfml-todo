import { inject } from '@angular/core';
import { Routes, Router, CanActivateFn, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { AuthService } from './auth.service';
import { SigninForm } from './sign-in.component';
import { SignupForm } from './sign-up.component';
import { ToDoList } from '../todo/todos.component';

let isLoggedIn: boolean = false;

const authGuard: CanActivateFn = (
  next: ActivatedRouteSnapshot,
  state: RouterStateSnapshot) => {
  // your  logic goes here
  const router = inject(Router);
  const authService = inject(AuthService);
  if ( authService.isLoggedIn ) {
    return true;
  }
  router.navigate(['/login']);
  return false;
}

export const routes: Routes = [
  { path: 'login', component: SigninForm },
  { path: 'signup', component: SignupForm },
  { path: '', component: ToDoList, canActivate: [authGuard] }
];
