import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';

@Injectable()
export class KafkaService implements OnModuleInit, OnModuleDestroy {
  onModuleInit() {}
  onModuleDestroy() {}
}