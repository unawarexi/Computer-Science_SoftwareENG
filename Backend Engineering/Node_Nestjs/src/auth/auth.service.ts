import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable({})
export class AuthService {
  constructor(private prisma: PrismaService) {}
  // This service will handle authentication logic
  // For example, login, register, etc.
  // You can add methods here to handle specific authentication tasks
  // For example:
  // async validateUser(username: string, password: string): Promise<any> {
  //   // Validate user credentials
  // }
  signIn() {
    // Logic for signing in a user
  }
  signUp() {
    // Logic for signing up a new user
  }
  signOut() {
    // Logic for signing out a user
  }
}
