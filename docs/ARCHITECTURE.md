# Architecture Documentation

## System Architecture

This document describes the architecture of the CI/CD pipeline.

### Components

1. **Source Control:** GitHub
2. **CI Server:** Jenkins
3. **Container Registry:** DockerHub
4. **Orchestration:** Kubernetes
5. **GitOps:** ArgoCD
6. **Code Quality:** SonarQube

### Data Flow
```
Developer → Git Push → GitHub → Webhook → Jenkins
    ↓
Jenkins → Maven Build → Tests → Package
    ↓
Jenkins → Docker Build → DockerHub
    ↓
Jenkins → Update K8s Manifest → Git Push
    ↓
ArgoCD → Detect Changes → Sync → Kubernetes
```

### Network Architecture

- Jenkins: Port 8080
- SonarQube: Port 9000
- ArgoCD: Port 8081
- Application: NodePort 30080

### Security

- Credentials stored in Jenkins Credentials Manager
- Kubernetes secrets for sensitive data
- RBAC enabled on Kubernetes cluster
- Network policies for pod-to-pod communication
