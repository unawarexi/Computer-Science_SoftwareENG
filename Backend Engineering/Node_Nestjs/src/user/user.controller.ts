import { Controller, Get, UseGuards } from "@nestjs/common";
import { Param } from "@nestjs/common";
// import { Injectable } from "@nestjs/common";
// import { PrismaService } from "src/prisma/prisma.service";
// import { User } from "@prisma/client";
// import { AuthService } from "src/auth/auth.service";
import { AuthGuard } from "@nestjs/passport";

@Controller("user")
export class UserController {
  @UseGuards(AuthGuard("jwt"))
  @Get()
  getAllUsers() {
    return "All users";
  }

  @Get(":id")
  getUserById(@Param("id") id: string) {
    return `User with id ${id}`;
  }
}
