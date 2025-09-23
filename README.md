# CICD Flask App Deploy To AWS EC2

## Demonstration

- **CI discipline**: automated tests on every PR/commit to `main`.
- **Immutable builds**: Docker image tagged with both `:latest` and the commit SHA.
- **Artifact management**: images published to **GHCR**.
- **Deployment automation**: GitHub Actions SSH to EC2, pull, and (re)start container.
- **Cloud fundamentals**: optional Terraform provisioning, secure secret handling.
- **Health-first services**: `/health` endpoint for checks and LB integration.