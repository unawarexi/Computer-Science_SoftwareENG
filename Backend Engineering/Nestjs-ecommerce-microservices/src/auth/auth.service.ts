import { Injectable, ForbiddenException } from "@nestjs/common";
import { PrismaService } from "src/prisma/prisma.service";
import { AuthDto } from "./dto";
import * as argon from "argon2";
import { JwtService } from "@nestjs/jwt";
import { ConfigService } from "@nestjs/config";

@Injectable({})
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwt: JwtService,
    private config: ConfigService,
  ) {}

  async signUp(dto: AuthDto) {
    // Hash the password
    const hash = await argon.hash(dto.password);

    try {
      // Create the user in the database
      const user = await this.prisma.users.create({
        data: {
          email: dto.email,
          hash,
        },
      });

      console.log("User created:", user); // Debugging log

      // Return the signed token
      return this.signToken(user.id, user.email);
    } catch (error) {
      console.error("Error during sign-up:", error); // Debugging log
      if (error.code === "P2002") {
        throw new ForbiddenException("Credentials taken");
      }
      throw error;
    }
  }

  async login(dto: AuthDto) {
    // Find the user by email
    const user = await this.prisma.users.findUnique({
      where: { email: dto.email },
    });

    console.log("User found during login:", user); // Debugging log

    // If user does not exist, throw an exception
    if (!user) {
      throw new ForbiddenException("Invalid credentials");
    }

    // Verify the password
    const passwordMatches = await argon.verify(user.hash, dto.password);
    console.log("Password matches:", passwordMatches); // Debugging log

    if (!passwordMatches) {
      throw new ForbiddenException("Invalid credentials");
    }

    // Return the signed token
    return this.signToken(user.id, user.email);
  }

  async signOut() {
    // Logic for signing out a user (e.g., invalidate tokens)
    // This can be implemented using a token blacklist or similar mechanism
    return { message: "User signed out successfully" };
  }

  async signToken(
    userId: string,
    email: string,
  ): Promise<{ accessToken: string }> {
    const payload = { sub: userId, email };
    const secret = this.config.get("JWT_SECRET");

    const token = await this.jwt.signAsync(payload, {
      expiresIn: "1h",
      secret,
    });

    console.log("Generated JWT token:", token); // Debugging log

    return { accessToken: token };
  }
}
