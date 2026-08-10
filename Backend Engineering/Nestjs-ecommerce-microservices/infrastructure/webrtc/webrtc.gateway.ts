import { WebSocketGateway, SubscribeMessage, MessageBody } from '@nestjs/websockets';

@WebSocketGateway({ namespace: '/webrtc' })
export class WebRTCGateway {
  @SubscribeMessage('offer')
  handleOffer(@MessageBody() data: any) {}
}