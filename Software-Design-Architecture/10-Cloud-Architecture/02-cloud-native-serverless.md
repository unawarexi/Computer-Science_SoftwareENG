# 02 - Cloud-Native & Serverless Architectures

Cloud-native architecture means designing systems specifically to take advantage of cloud computing models, rather than just "lifting and shifting" an old application into a cloud VM.

## 1. Serverful vs. Serverless
- **Serverful (EC2):** You provision a server, install the OS, keep it patched, pay for it 24/7 (even if no one is using it), and manually scale it up when traffic spikes.
- **Serverless:** You write the code, and the cloud provider handles *everything* else. You pay only for the exact milliseconds your code executes. It scales from 0 to 10,000 concurrent requests instantly.

## 2. Serverless Compute
- **Functions as a Service (FaaS):** AWS Lambda, GCP Cloud Functions. You upload a function (Node.js, Python, Go) and it runs in response to an event (like an HTTP request or a file upload to S3).
- **Serverless Containers:** AWS Fargate, GCP Cloud Run. You upload a Docker container, and the cloud runs it and scales it without you provisioning the underlying nodes.

## 3. Event-Driven Architecture
Serverless architectures are inherently event-driven. Components don't call each other directly; they emit events.
- **Pub/Sub and Queues:** AWS SNS (Pub/Sub) and SQS (Queuing). GCP Pub/Sub. Used to decouple microservices. If an order is placed, an event is sent to a queue, and multiple serverless functions can pick it up to process payment, send an email, and update inventory.
- **Event Buses:** AWS EventBridge. A central hub that routes events between your applications, SaaS apps, and AWS services.

## 4. API Gateways
- **AWS API Gateway:** Sits in front of your Lambda functions. It handles HTTP routing, authentication (via Cognito or JWTs), rate limiting, and CORS, passing the clean request to your serverless code.

---
**Next Step:** Ensure your architecture stays alive during a crisis in [03 - High Availability & Resiliency Design](./03-high-availability-resiliency.md).
