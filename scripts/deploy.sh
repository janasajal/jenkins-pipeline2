#!/bin/bash

set -e

echo "Deploying application to Kubernetes..."

# Apply Kubernetes manifests
kubectl apply -f k8s/deployment.yaml

echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=spring-boot-app -n default --timeout=120s

echo "Deployment complete!"
echo ""
echo "Access application:"
minikube service spring-boot-app-service --url
