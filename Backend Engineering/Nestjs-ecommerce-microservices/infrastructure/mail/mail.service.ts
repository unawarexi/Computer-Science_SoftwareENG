import { Injectable } from '@nestjs/common';

@Injectable()
export class MailService {
  async sendEmail(to: string, subject: string, body: string) {}
}