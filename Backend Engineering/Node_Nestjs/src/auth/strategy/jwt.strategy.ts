import { ExtractJwt, Strategy } from "passport-jwt";
import { PassportStrategy } from "@nestjs/passport";
import { ConfigService } from "@nestjs/config";
import { Injectable } from "@nestjs/common";

/**
 * - Implements JWT authentication strategy using Passport.js.
 * - Extracts JWT token from the Authorization header as a Bearer token.
 * - Validates the token and ensures it is not expired.
 * - Uses the secret key from environment variables for token verification.
 * - Provides user details (userId and email) from the token payload.
 */
@Injectable()
export class jwtStrategy extends PassportStrategy(Strategy, "jwt") {
  constructor(config: ConfigService) {
    // Call the parent constructor with the JWT options
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: config.get("JWT_SECRET"),
    });
  }

  async validate(payload: any) {
    return { userId: payload.sub, email: payload.email };
  }
}
