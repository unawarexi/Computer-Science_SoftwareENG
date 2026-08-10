import { Global, Module } from '@nestjs/common';
import { PrismaService } from './prisma.service';

@Global()
// This module is global, so it can be used in any module without importing it
// in the module's imports array
// This is useful for services that are used across multiple modules
// and you don't want to import them in every module
// For example, PrismaService is used in multiple modules
// and you don't want to import it in every module
// @Global() decorator makes the module global
@Module({
  providers: [PrismaService],
  exports: [PrismaService],
})
export class PrismaModule {}
