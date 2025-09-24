# CICD Flask App Deploy To AWS EC2

## A production-style pipeline that:
1) runs **pytest**,  
2) builds & pushes a Docker image to **GitHub Container Registry (GHCR)**,  
3) deploys to a single **EC2** host via SSH + Docker.

## Demonstration
- **CI discipline**: automated tests on every PR/commit to `main`.
- **Immutable builds**: Docker image tagged with both `:latest` and the commit SHA.
- **Artifact management**: images published to **GHCR**.
- **Deployment automation**: GitHub Actions SSH to EC2, pull, and (re)start container.
- **Cloud fundamentals**: optional Terraform provisioning, secure secret handling.
- **Health-first services**: `/health` endpoint for checks and LB integration.

## Architecture
**Runtime**
- Flask app served by **gunicorn** inside a container.
- Routes: `GET /` and `GET /health`.

## Prerequisites
### GitHub & Registry
- A GitHub repository (this code).
- **GHCR** enabled on your account/org.
- CI uses repository **GITHUB_TOKEN** to **push** images to GHCR.
- EC2 pulls images using a **GitHub Personal Access Token** with **`read:packages`**.

### AWS (EC2 host)
Use an **existing** EC2 instance or provision one with Terraform:
- OS: Amazon Linux 2023 (recommended) or Ubuntu 22.04.
- Inbound Security Group:
  - **TCP 22** from *your IP* (SSH),
  - **TCP 80** from `0.0.0.0/0` (demo HTTP).
- SSH user: `ec2-user` (Amazon Linux) or `ubuntu` (Ubuntu).

### Local (optional)
- Python **3.12+**, `pip`, `venv`
- Docker Engine

## Quick Start (Local)
### Create & Activate venv
```bash
# Create & activate venv
python -m venv .venv && source .venv/bin/activate
```
### Install deps & run tests
```bash
pip install -r requirements.txt
pytest -q
```
### Build & run Docker locally
```bash
docker build -t flask:local .
docker run -d -p 8080:8000 --name flaskapp flask:local
curl http://localhost:8080/health
```

## CI/CD: How It Works
- Workflow: .github/workflows/ci-cd.yml

1. Test
Checkout → Install deps → pytest (validates / and /health).

2. Build & Push
- Login to GHCR with GITHUB_TOKEN.
- Build Docker image and tag as:
- ghcr.io/<OWNER>/<REPO>:latest
- ghcr.io/<OWNER>/<REPO>:<GITHUB_SHA>
- Push both tags.

3. Deploy
- SSH into EC2 using EC2_SSH_KEY.
- Install Docker if missing.
- Login to GHCR on the server using GHCR_TOKEN (read-only).
- Pull :latest, stop old container, run new one (-p 80:8000).
- Health check against http://localhost/health.

## Configure GitHub Secrets
Repository → Settings → Secrets and variables → Actions

EC2_HOST	     54.XX.XX.XX or ec2-xx-xx-xx.compute.amazonaws.com
EC2_USER	     ec2-user (Amazon Linux) or ubuntu (Ubuntu)
EC2_SSH_KEY	     Private SSH key contents (PEM) for the EC2 key pair (paste file contents)
GHCR_USERNAME	 Your GitHub username
GHCR_TOKEN	     PAT with read:packages (server-side docker pull from GHCR)

The workflow already sets permissions.packages: write so GITHUB_TOKEN can push images.