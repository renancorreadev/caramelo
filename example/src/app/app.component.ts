import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { LoginComponent } from './pages/login/login.component'; // Importe o LoginComponent

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  standalone: true,
  imports: [CommonModule, LoginComponent], // Adicione LoginComponent aqui
})
export class AppComponent {
  title = 'wallet-login-app';
}
