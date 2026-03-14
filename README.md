# Deploy Manufacturing App to Kubernetes

**A Complete DevOps Workflow with Docker · CI/CD · Rolling Updates**

---

## 01 — Project Overview

This project demonstrates the deployment of a Python Flask Manufacturing Application onto a Kubernetes cluster (Minikube) using a complete DevOps workflow. The system uses containerization, CI/CD automation, and Kubernetes orchestration to manage application deployment efficiently.

The project implements **rolling updates** to ensure zero downtime deployment, allowing new application versions to be released seamlessly without interrupting service availability.

---

## 02 — Problem Statement

Modern manufacturing applications must remain highly available while new features and fixes are continuously deployed. Traditional deployment methods often cause service downtime, manual configuration errors, and inconsistent environments across development and production systems.

**This project solves the problem by ensuring:**

- Reliable and repeatable application deployment
- Zero downtime during updates
- Scalable infrastructure management
- Automated CI/CD workflows

---

## 03 — Architecture Overview

The deployment follows a modern DevOps pipeline:

```
Developer → Git Repository → CI/CD Pipeline (Jenkins / GitHub Actions)
         → Docker Image Build → Container Registry
         → Kubernetes Deployment → Service Exposure
         → Users Access Application
```

**Key Components**

| Component | Role |
|---|---|
| Git | Source code version control |
| Docker | Containerization of the Flask application |
| Jenkins / GitHub Actions | CI/CD automation |
| Kubernetes (Minikube) | Container orchestration |
| Rolling Updates | Zero-downtime deployment strategy |

---

## 04 — Tech Stack

| Technology | Purpose |
|---|---|
| Python Flask | Manufacturing web application |
| Docker | Containerization |
| Kubernetes | Container orchestration |
| Minikube | Local Kubernetes cluster |
| Jenkins / GitHub Actions | CI/CD automation |
| Git | Version control |

---

## 05 — Project Structure

```
manufacturing-k8s-app/
├── app/
│   ├── app.py
│   └── requirements.txt
├── docker/
│   └── Dockerfile
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
├── .github/workflows/
│   └── ci-cd-pipeline.yml
├── Jenkinsfile
└── README.md
```

---

## 06 — Deployment Steps

### Step 1 — Dockerize the Application

Build and run the Docker image locally:

```bash
docker build -t manufacturing-app:1.0 .
docker run -p 5000:5000 manufacturing-app:1.0
```

### Step 2 — Start Kubernetes Cluster

```bash
minikube start
kubectl get nodes
```

### Step 3 — Create Kubernetes Deployment

```bash
kubectl apply -f k8s/deployment.yaml
kubectl get pods
```

### Step 4 — Expose the Application

```bash
kubectl apply -f k8s/service.yaml
minikube service manufacturing-service
```

### Step 5 — Rolling Updates (Zero Downtime)

```bash
# Update to new version
kubectl set image deployment/manufacturing-deployment app=manufacturing-app:2.0

# Monitor rollout
kubectl rollout status deployment/manufacturing-deployment

# Rollback if needed
kubectl rollout undo deployment/manufacturing-deployment
```

---

## 07 — CI/CD Pipeline

The pipeline automates the full deployment lifecycle:

| # | Stage | Action |
|---|---|---|
| 1 | Source Control | Code pushed to Git repository |
| 2 | Image Build | Docker image built from source |
| 3 | Registry Push | Image pushed to container registry |
| 4 | Deploy | Kubernetes deployment updated |
| 5 | Rolling Update | Zero-downtime rollout executed |

**Tools:** Jenkins Pipeline · GitHub Actions

---

## 08 — Key Features

- ✔ Containerized Flask application
- ✔ Kubernetes deployment with scalable pods
- ✔ Zero-downtime rolling updates
- ✔ Automated CI/CD pipeline
- ✔ Infrastructure as Code using YAML manifests
- ✔ Local Kubernetes testing with Minikube

---

## 09 — Testing the Deployment

```bash
kubectl get pods       # Verify pods are running
kubectl get svc        # Check service endpoints
kubectl logs <pod>     # Stream application logs
```

---

## 10 — Future Enhancements

- Helm chart deployment
- Horizontal Pod Autoscaling (HPA)
- Monitoring with Prometheus & Grafana
- Kubernetes Ingress configuration
- Cloud deployment to AWS EKS / GKE

---

## 11 — Authors

Om Tiwari · Paridhi Shirwalkar · Nitesh Chourasiya · Mradul Jain
