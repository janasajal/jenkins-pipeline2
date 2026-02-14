#!/bin/bash

set -e

echo "=================================="
echo "CI/CD Pipeline Setup Script"
echo "=================================="

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}➜ $1${NC}"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   exit 1
fi

print_info "Step 1: Updating system..."
sudo apt update && sudo apt upgrade -y
print_success "System updated"

print_info "Step 2: Installing Java 17..."
sudo apt install -y openjdk-17-jdk openjdk-17-jre
print_success "Java installed: $(java -version 2>&1 | head -n 1)"

print_info "Step 3: Installing Maven..."
sudo apt install -y maven
print_success "Maven installed: $(mvn -version | head -n 1)"

print_info "Step 4: Installing Docker..."
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
print_success "Docker installed"

print_info "Step 5: Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl
print_success "kubectl installed"

print_info "Step 6: Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64
print_success "Minikube installed"

print_info "Step 7: Installing Jenkins..."
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo usermod -aG docker jenkins
print_success "Jenkins installed"

print_info "Step 8: Starting Minikube..."
newgrp docker << EONG
minikube start --driver=docker --cpus=2 --memory=4096mb
EONG
print_success "Minikube started"

print_info "Step 9: Installing ArgoCD..."
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
print_success "ArgoCD installed"

echo ""
echo "=================================="
echo "Setup Complete!"
echo "=================================="
echo ""
echo "Next steps:"
echo "1. Access Jenkins: http://$(hostname -I | awk '{print $1}'):8080"
echo "2. Get Jenkins password: sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
echo "3. Access ArgoCD: kubectl port-forward svc/argocd-server -n argocd 8081:443 --address=0.0.0.0 &"
echo "4. Get ArgoCD password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
echo ""
echo "Please logout and login again to apply docker group changes!"
