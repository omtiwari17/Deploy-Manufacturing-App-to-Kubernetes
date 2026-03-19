# Deploy Manufacturing App to Kubernetes

A complete DevOps implementation for containerizing and deploying a Multi-Agent Manufacturing System onto AWS EKS using Docker, Kubernetes, and GitHub Actions CI/CD with zero-downtime rolling updates.

---

## Project Overview

This project takes the Multi-Agent Manufacturing System built with Python, Streamlit, and CrewAI and deploys it to a production-grade AWS EKS Kubernetes cluster. The deployment is fully automated a single `git push` triggers the entire build, push, and deploy pipeline with no manual steps required.

The key feature is zero-downtime Rolling Updates. When a new version is deployed, Kubernetes replaces pods gradually ensuring the app stays available throughout the entire update process.

---

## Key Features

- Automated CI/CD pipeline triggered on every `git push`
- Zero-downtime Rolling Updates using Kubernetes deployment strategy
- Docker containerization with GitHub-based build no local builds needed
- Two-repository architecture- DevOps repo contains zero application code
- Deployed on AWS EKS with auto-provisioned nodes and public Load Balancer
- Health-check-driven deployments using Streamlit's `/_stcore/health` endpoint
- All credentials managed via GitHub Secrets nothing stored in code or images
---

## Tech Stack

| Category | Technology |
|---|---|
| Application | Python, Streamlit, CrewAI, Google Gemini LLM |
| Containerization | Docker, Docker Hub |
| Orchestration | Kubernetes (AWS EKS) |
| CI/CD | GitHub Actions |
| Cloud | AWS EKS, AWS EC2, AWS Load Balancer |
| Version Control | Git, GitHub |

---

## Project Structure

```
Deploy-Manufacturing-App-to-Kubernetes/
│
├── Dockerfile                        # Clones AI repo and runs Streamlit
├── requirements.txt                  # Clean Linux-compatible dependencies
├── .dockerignore                     # Files excluded from Docker build
├── .gitattributes                    # Git line ending rules for Linux
│
├── k8s/
│   ├── deployment.yaml               # Pods, replicas, rolling update config
│   └── service.yaml                  # AWS LoadBalancer service on port 80
│
└── .github/
    └── workflows/
        └── deploy.yml                # Full CI/CD pipeline definition
```

---

## Two-Repository Strategy

The AI application code and DevOps infrastructure are maintained in completely separate repositories. The `Dockerfile` clones the `Multi-agent-system` repo at build time using `git clone`, keeping this repo pure infrastructure. This means the AI team and DevOps team can work independently without interfering with each other.

---

## Deployment Steps

Follow these steps to deploy this project from scratch.

**Prerequisites**
- AWS account with an IAM user that has EKS and EC2 permissions
- Docker Desktop installed
- AWS CLI installed and configured (`aws configure`)
- kubectl installed
- Docker Hub account

**Step 1- Clone this repository**
```bash
git clone https://github.com/omtiwari17/Deploy-Manufacturing-App-to-Kubernetes.git
cd Deploy-Manufacturing-App-to-Kubernetes
```

**Step 2- Create AWS EKS Cluster**

Go to AWS Console → EKS → Create Cluster. Use Custom configuration with Auto Mode enabled, name it `multi-agent-cluster`, select region `ap-south-1`, and attach your cluster IAM role. Wait 10–15 minutes for the cluster to become Active.

**Step 3- Connect kubectl to the cluster**
```bash
aws eks update-kubeconfig --region ap-south-1 --name multi-agent-cluster
kubectl get nodes
```

**Step 4- Tag VPC subnets for Load Balancer**

Go to AWS Console → VPC → Subnets. For each public subnet (ones with an Internet Gateway in their route table), add this tag:
```
Key:   kubernetes.io/role/elb
Value: 1
```

**Step 5- Add GitHub Secrets**

Go to your GitHub repo → Settings → Secrets and variables → Actions and add these secrets:
```
DOCKER_USERNAME        → your Docker Hub username
DOCKER_PASSWORD        → your Docker Hub access token
AWS_ACCESS_KEY_ID      → your IAM user access key
AWS_SECRET_ACCESS_KEY  → your IAM user secret key
AWS_REGION             → ap-south-1
```

**Step 6- Push to trigger the pipeline**
```bash
git push origin main
```

Go to the Actions tab on GitHub and watch all stages complete. The pipeline builds the image, pushes to Docker Hub, and deploys to EKS automatically.

**Step 7- Fix service selector and security group**
```bash
kubectl apply -f k8s/service.yaml
```

Go to AWS Console → EC2 → worker node → Security Group → Edit inbound rules. Add port 80 and port 8501 with source `0.0.0.0/0`.

**Step 8- Get the app URL**
```bash
kubectl get services
```

Copy the `EXTERNAL-IP` value and open `http://EXTERNAL-IP` in any browser.

---

## CI/CD Pipeline Stages

```
Stage 1 — Checkout
  └─ Pull latest code from DevOps repository

Stage 2 — Docker Login
  └─ Authenticate with Docker Hub using stored secrets

Stage 3 — Build Image
  └─ Build Docker image on GitHub runner
  └─ Dockerfile clones Multi-agent-system repo inside

Stage 4 — Push Image
  └─ Push tiwariom/multi-agent-manufacturing-system:latest to Docker Hub

Stage 5 — AWS Auth
  └─ Configure AWS credentials from GitHub Secrets
  └─ Update kubeconfig to point kubectl at EKS cluster

Stage 6 — Deploy
  └─ kubectl apply k8s/deployment.yaml
  └─ kubectl apply k8s/service.yaml

Stage 7 — Verify
  └─ kubectl rollout status — waits until all pods are healthy
  └─ kubectl get pods + services — confirms live state
```

---

## Zero-Downtime Rolling Update

The deployment is configured with `replicas: 2`, `maxSurge: 1`, and `maxUnavailable: 0`. This means Kubernetes always spins up a new pod and waits for it to pass the health check before terminating an old one. Users never experience downtime during any deployment. The health check uses Streamlit's built-in `/_stcore/health` endpoint.

---

## GitHub Secrets Required

Before the pipeline can run, these five secrets must be added to the repository under Settings → Secrets and variables → Actions `DOCKER_USERNAME`, `DOCKER_PASSWORD`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_REGION`.

---

## Related Repository

AI Application → https://github.com/omtiwari17/Multi-agent-system

Docker Hub Image → https://hub.docker.com/r/tiwariom/multi-agent-manufacturing-system

---

## Group Members

| Sr No | Name | Enrollment Number |
|---|---|---|
| 01 | Om Tiwari | EN22CS301669 |
| 02 | Paridhi Shirwalkar | EN22CS301684 |
| 03 | Nitesh Chourasiya | EN22CS301660 |
| 04 | Mradul Jain | EN22CS301616 |

---

- **Institution**- Medicaps University, Datagami Skill Based Course
- **Academic Year**- 2025-2026
- **Industry Mentor**- Prof. Akshay Saxena