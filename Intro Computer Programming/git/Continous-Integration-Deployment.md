Continuous Integration and Continuous Deployment (CI/CD) – Student Guide
Table of Contents

Introduction

What is Continuous Integration (CI)?

What is Continuous Deployment/Delivery (CD)?

Why CI/CD is Important

External Tools for CI/CD

CI/CD for Different Stacks

Mobile Development (Android & iOS)

Web Development (MERN/Next.js)

Backend Development (Node.js, Python, Java, etc.)

Containers and Docker in CI/CD

Automation and Testing in CI/CD

Best Practices

References & Resources

Introduction

Continuous Integration (CI) and Continuous Deployment/Delivery (CD) are software engineering practices that allow teams to:

Automatically build, test, and deploy code.

Detect and fix issues early.

Deliver updates quickly and reliably.

Together, CI/CD helps teams maintain high-quality, fast, and predictable software releases.

What is Continuous Integration (CI)?

CI is the practice of merging code changes frequently into a shared repository.

Every merge triggers automated builds and tests.

CI ensures integration issues are detected early.

Key Components:

Version control system (Git)

Automated build tools

Automated test suites

What is Continuous Deployment/Delivery (CD)?

Continuous Delivery: Code is automatically built and tested, ready for deployment. Deployment may still require manual approval.

Continuous Deployment: Every change that passes CI is automatically deployed to production.

Benefits:

Faster release cycles

Lower risk of errors in production

High confidence in deployment

Why CI/CD is Important

Early bug detection – Tests run automatically on each commit.

Faster release cycles – Automate build, test, and deployment.

Consistency – Standardized deployment process.

Collaboration – Team members integrate changes frequently.

Rollback & traceability – Easy to track and revert changes if needed.

External Tools for CI/CD

Some popular CI/CD tools include:

Tool	Description	Platforms
GitHub Actions	Integrated CI/CD in GitHub	Web, Mobile, Backend
GitLab CI/CD	Integrated CI/CD in GitLab	Web, Mobile, Backend
CircleCI	Cloud-based CI/CD	Web, Mobile, Backend
Jenkins	Open-source automation server	Web, Mobile, Backend
Travis CI	Cloud-based CI/CD	Web, Mobile
Bitrise	CI/CD for mobile apps (iOS & Android)	Mobile
Fastlane	Automates building and releasing mobile apps	Mobile (iOS & Android)
CI/CD for Different Stacks
Mobile Development (Android & iOS)

Requirements:

Build Tools: Gradle (Android), Xcode (iOS)

Stores: Google Play, Apple App Store

CI/CD Tools: GitHub Actions, Bitrise, CircleCI, Fastlane

Testing: Unit tests, UI tests (Espresso for Android, XCTest for iOS), Beta testing via TestFlight or Firebase App Distribution

Workflow Example:

Developer pushes code to feature branch.

CI runs: build APK/IPA, run tests.

CD deploys to Google Play Beta / TestFlight.

After approval, CD deploys to production stores.

Web Development (MERN/Next.js)

Requirements:

Stack: MongoDB, Express, React, Node.js, Next.js

Build Tools: npm, yarn, Next.js build commands

Hosting: Vercel, Netlify, AWS, Heroku, or Docker containers

CI/CD Tools: GitHub Actions, GitLab CI/CD, Jenkins

Testing: Jest, React Testing Library, Cypress (E2E tests)

Workflow Example:

Push code to GitHub.

CI runs: install dependencies, run tests, build production bundle.

CD deploys to Vercel, Netlify, or Docker container.

Backend Development (Node.js, Python, Java, etc.)

Requirements:

Stack: Node.js/Express, Django/Flask, Spring Boot, etc.

Databases: PostgreSQL, MySQL, MongoDB, Redis

Hosting: AWS EC2, Heroku, DigitalOcean, Docker containers

CI/CD Tools: GitHub Actions, GitLab CI/CD, Jenkins, CircleCI

Testing: Unit tests (Jest, Mocha, PyTest, JUnit), Integration tests

Workflow Example:

Developer pushes backend code.

CI runs: install dependencies, run tests, build Docker image.

CD deploys Docker container to staging/production.

Containers and Docker in CI/CD

Why use Docker/containers:

Standardized environment across development, testing, and production

Easy to deploy microservices

Integrates well with CI/CD pipelines

CI/CD Example with Docker:

Build Docker image from Dockerfile in CI.

Run automated tests inside Docker container.

Push Docker image to registry (Docker Hub, AWS ECR).

Deploy image to Kubernetes, ECS, or other container orchestration platforms.

Automation and Testing in CI/CD

Automation Tasks:

Run unit tests automatically

Run integration tests

Linting and code formatting checks

Security scans (Snyk, Dependabot)

Build and package artifacts (APK, IPA, Docker images)

Deploy to staging/production automatically

Testing Levels:

Unit Tests: Test individual components

Integration Tests: Test combined components or services

End-to-End (E2E) Tests: Test full workflows in app

UI/UX Tests: Ensure mobile/web interface works as expected

Best Practices

Automate as much as possible – Builds, tests, deployments.

Keep CI pipelines fast – Long pipelines slow down development.

Use separate environments – Dev, staging, production.

Fail fast – Detect errors as early as possible.

Monitor deployments – Logs, alerts, dashboards.

Secure secrets – API keys, store credentials in CI/CD secret manager.

Use versioned artifacts – APKs, Docker images, npm packages.

References & Resources

GitHub Actions Documentation

GitLab CI/CD Documentation

Jenkins Documentation

Fastlane for Mobile CI/CD

Docker CI/CD Workflows