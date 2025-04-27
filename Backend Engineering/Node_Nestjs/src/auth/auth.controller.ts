import { Body, Controller, Post } from "@nestjs/common";
import { AuthService } from "./auth.service";
import { AuthDto } from "./dto";

@Controller("auth")
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

  @Post("login")
  async login(@Body() dto: AuthDto) {
    console.log("Login request data:", dto); // Debugging log
    const response = await this.authService.login(dto);
    console.log("Login response data:", response); // Debugging log
    return response;
  }

  @Post("register")
  async register(@Body() dto: AuthDto) {
    console.log("Register request data:", dto); // Debugging log
    const response = await this.authService.signUp(dto);
    console.log("Register response data:", response); // Debugging log
    return response;
  }

  @Post("logout")
  async logout() {
    console.log("Logout request received"); // Debugging log
    const response = await this.authService.signOut();
    console.log("Logout response data:", response); // Debugging log
    return response;
  }
}
