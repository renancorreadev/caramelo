import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule } from '@angular/forms';
import { AuthService } from 'src/app/service/auth.service';
// Certifique-se do caminho correto para o AuthService

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css'],
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
})
export class LoginComponent {
  loginForm!: FormGroup;

  constructor(private fb: FormBuilder, private authService: AuthService) {
    this.loginForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required, Validators.minLength(6)]],
    });
  }

  async onSubmit() {
    if (this.loginForm.valid) {
      const { email, password } = this.loginForm.value;

      try {
        // Chama o serviço de autenticação para realizar o login
        const token = await this.authService.login(email, password);
        console.log('Login Successful. Token:', token);
        alert('Login Successful!');
      } catch (error: any) {
        console.error('Login Failed:', error);
        alert(error.message || 'Login Failed. Please try again.');
      }
    } else {
      alert('Invalid Form. Please fill out the form correctly.');
    }
  }
}
