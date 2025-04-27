import { Module } from "@nestjs/common";
import { AuthController } from "./auth.controller";
import { AuthService } from "./auth.service";
import { JwtModule } from "@nestjs/jwt";
import { jwtStrategy } from "./strategy";

@Module({
  imports: [JwtModule.register({})],
  // You can import other modules here if needed
  // For example, if you have a UserModule for user-related operations
  controllers: [AuthController],
  providers: [AuthService, jwtStrategy],
})
export class AuthModule {}
