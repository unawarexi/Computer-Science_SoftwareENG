# 01 - CI/CD Pipelines and Release Strategies

Continuous Integration and Continuous Deployment (CI/CD) form the backbone of modern software delivery, automating the journey from a developer's commit to production.

## 1. Continuous Integration (CI)
CI is the practice of merging all developers' working copies to a shared mainline several times a day.
- **Goal:** Detect integration errors as quickly as possible.
- **Pipeline Steps:** Linting, compiling, running unit tests, and building artifacts (like Docker images).
- **Tools:** GitHub Actions, GitLab CI, Jenkins, CircleCI.

## 2. Continuous Delivery / Deployment (CD)
- **Continuous Delivery:** Automates the release process so that the software can be deployed reliably at any time. The actual deployment to production requires manual approval (a push of a button).
- **Continuous Deployment:** Every change that passes all stages of the production pipeline is released to customers dynamically, with no human intervention.

## 3. Advanced Release Strategies
Releasing a new version replacing the old one (Recreate deployment) causes downtime. Architects use advanced strategies to mitigate risk:
- **Blue-Green Deployment:** Two identical environments (Blue and Green). One is live, one is idle. You deploy the new version to the idle environment, test it, and then instantly switch the router/load balancer to point to the new one. Rollbacks are instant.
- **Canary Releases:** Roll out the new version to a small subset of users (e.g., 5%). Monitor errors and performance. If stable, gradually increase to 100%.
- **Feature Flags (Toggles):** Decouple deployment from release. Deploy code to production with the feature turned off in configuration. Turn it on for specific users or globally at a later time (e.g., using LaunchDarkly).
- **Shadow Traffic (Dark Launch):** Send a copy of live production traffic to the new version without affecting user responses. Great for testing performance and correctness safely.

---
**Next Step:** Learn how to package your applications reliably in [02 - Containerization & DevSecOps](./02-containerization.md).
