# Troubleshooting Guide

## Common Issues and Solutions

### Jenkins Issues

#### Build Fails with "Permission Denied"
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

#### Cannot Access Jenkins UI
```bash
sudo systemctl status jenkins
sudo ufw allow 8080
```

### Docker Issues

#### Cannot Pull Images
```bash
docker login
sudo systemctl restart docker
```

### Kubernetes Issues

#### Pods in CrashLoopBackOff
```bash
kubectl logs <pod-name>
kubectl describe pod <pod-name>
```

#### Service Not Accessible
```bash
kubectl get svc
minikube service <service-name> --url
```

### ArgoCD Issues

#### Application Not Syncing
```bash
kubectl get applications -n argocd
kubectl describe application <app-name> -n argocd
```
