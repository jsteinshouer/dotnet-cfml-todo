import { Injectable, inject } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  isLoggedIn: boolean = false;
  token: string = "";
  tokenExiration: Date = new Date();
  refreshToken = "";

  constructor() {

    const authData = localStorage.getItem("auth");
    if (authData && JSON.parse(authData)) {
      const auth = JSON.parse(authData);
      if ( new Date(auth.expires).getTime() > new Date().getTime() ) {
        this.isLoggedIn = true;
        this.token = auth.token;
        this.tokenExiration = auth.exires;
      }
    }
  }

  async login(email: string, password: string) {
    const response = await fetch("/api/login", {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        "email": email,
        "password": password
      })
    });

    if ( response.ok ) {
      const responseData = await response.json();
      this.isLoggedIn = true;
      this.tokenExiration = new Date(new Date().getTime() + responseData.expiresIn * 1000);
      this.token = responseData.accessToken;
      this.refreshToken = responseData.refreshToken;

      localStorage.setItem("auth", JSON.stringify( {
        "token": this.token,
        "expires": this.tokenExiration
      }));
      return true;
    }

    return false;
    // console.log(response);
  }

  async register(
    email: string,
    password: string
  ) {
    const response = await fetch("/api/register", {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        "email": email,
        "password": password
      })
    });

    if ( response.ok ) {
      return true;
    }
    return false;

  }

}
