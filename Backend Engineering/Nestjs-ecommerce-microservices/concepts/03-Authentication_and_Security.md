# Authentication, Security & Middlewares

## Overview
Protecting our APIs and managing user identities securely.

## Topics
1. **Authentication (Auth)**
   - **JWT (JSON Web Tokens)**: Stateless authentication.
   - **OAuth2 & OIDC**: Social logins and delegated access.
   - Refresh tokens and token revocation strategies.

2. **Security Best Practices**
   - **CORS & Helmet**: Setting HTTP headers for security.
   - **Rate Limiting**: Throttling requests to prevent brute-force and DDoS attacks.
   - **Data Validation & Sanitation**: Using `class-validator` and `class-transformer` in NestJS.
   - Preventing SQL injection and XSS.

3. **NestJS Specifics**
   - **Middlewares**: Request logging, IP tracking.
   - **Guards**: Role-Based Access Control (RBAC) and Claims-Based Access Control.
   - **Interceptors**: Response mapping, global error handling, and performance logging.
