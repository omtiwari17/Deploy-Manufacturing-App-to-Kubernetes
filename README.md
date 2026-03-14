Deploy Manufacturing App to Kubernetes
------------------------------------------
 Project Overview
--------------------
This project demonstrates the deployment of a Python Flask Manufacturing Application onto a Kubernetes cluster (Minikube) using a complete DevOps workflow. The system uses containerization, CI/CD automation, and Kubernetes orchestration to manage application deployment efficiently.

The project implements rolling updates to ensure zero downtime deployment, allowing new application versions to be released seamlessly without interrupting service availability.

❗ Problem Statement

Modern manufacturing applications must remain highly available while new features and fixes are continuously deployed. Traditional deployment methods often cause service downtime, manual configuration errors, and inconsistent environments across development and production systems.

The challenge is to build a deployment pipeline that ensures:

Reliable and repeatable application deployment

Zero downtime during updates

Scalable infrastructure management

Automated CI/CD workflows

This project solves the problem by using Docker for containerization, Kubernetes for orchestration, and CI/CD pipelines to automate the deployment process.

 Architecture Overview
-------------------------
The deployment follows a modern DevOps architecture:

Developer → Git Repository → CI/CD Pipeline (Jenkins / GitHub Actions)
           → Docker Image Build → Container Registry
           → Kubernetes Deployment → Service Exposure
           → Users Access Application
Key Components
--------------
Git – Source code version control

Docker – Containerization of the Flask application

Jenkins / GitHub Actions – CI/CD automation

Kubernetes (Minikube) – Container orchestration

Rolling Updates – Zero downtime deployment strategy

 Tech Stack
--------------
Technology	Purpose
Python Flask	Manufacturing web application
Docker	Containerization
Kubernetes	Container orchestration
Minikube	Local Kubernetes cluster
Jenkins / GitHub Actions	CI/CD automation
Git	Version control

 Project Structure
---------------------
manufacturing-k8s-app/
│
├── app/
│   ├── app.py
│   └── requirements.txt
│
├── docker/
│   └── Dockerfile
│
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
│
├── .github/workflows/
│   └── ci-cd-pipeline.yml
│
├── Jenkinsfile
│
└── README.md
🐳 Step 1 — Dockerize the Application

Build the Docker image:

docker build -t manufacturing-app:1.0 .

Run locally:

docker run -p 5000:5000 manufacturing-app:1.0
☸️ Step 2 — Start Kubernetes Cluster

Start Minikube:

minikube start

Verify cluster:

kubectl get nodes
📦 Step 3 — Create Kubernetes Deployment

Apply deployment manifest:

kubectl apply -f k8s/deployment.yaml

Check pods:

kubectl get pods
🌐 Step 4 — Expose the Application

Expose the deployment:

kubectl apply -f k8s/service.yaml

Access the application:

minikube service manufacturing-service
🔄 Step 5 — Rolling Updates (Zero Downtime)

Update the container image:

kubectl set image deployment/manufacturing-deployment app=manufacturing-app:2.0

Monitor rollout:

kubectl rollout status deployment/manufacturing-deployment

Rollback if needed:

kubectl rollout undo deployment/manufacturing-deployment

 CI/CD Pipeline
------------------

The CI/CD pipeline automates:

Code push to Git repository

Docker image build

Image push to container registry

Kubernetes deployment update

Rolling update of application

Tools used:

Jenkins Pipeline

GitHub Actions

 Key Features
 -------------

✔ Containerized Flask application
✔ Kubernetes deployment with scalable pods
✔ Zero-downtime rolling updates
✔ CI/CD automation
✔ Infrastructure as Code using YAML manifests
✔ Local Kubernetes testing with Minikube

 Testing the Deployment
---------------------------

Check pods:

kubectl get pods

Check services:

kubectl get svc

View logs:

kubectl logs <pod-name>

 Future Enhancements
--------------------
Helm chart deployment

Horizontal Pod Autoscaling (HPA)

Monitoring with Prometheus & Grafana

Kubernetes Ingress configuration

Deployment to cloud Kubernetes (AWS EKS / GKE)

 Authors
 --------
Om Tiwari
Paridhi Shirwalkar
Nitesh Chourasiya
Mradul Jain
