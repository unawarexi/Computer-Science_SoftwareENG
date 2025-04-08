import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthDto } from './dto';

@Controller('auth')
export class AuthController {
  // This controller will handle authentication-related routes
  // For example, login, register, etc.
  // You can add methods here to handle specific routes
  // For example:
  // @Post('login')
  // async login(@Body() loginDto: LoginDto) {
  //   return this.authService.login(loginDto);
  // }

  constructor(private authService: AuthService) {
    // You can inject the AuthService here to use its methods
  }

  @Post('login')
  async login() {
    return this.authService.signIn();
  }

  @Post('register')
  async register(@Body() dto: AuthDto) {
    // You can use the body to get the user data from the request
    // For example:
    // const { username, password } = body;
    // return this.authService.register(username, password);
    // Or you can use a DTO (Data Transfer Object) to validate the data
    // For example:
    // const registerDto = new RegisterDto();
    console.log({ dto });
    return this.authService.signUp();
  }

  @Post('logout')
  async logout() {
    return this.authService.signOut();
  }
}
