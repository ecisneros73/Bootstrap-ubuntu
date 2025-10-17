#!/bin/bash
# Jenkins and DevOps Tools Installer Script

set -e  # Exit on any error
set -o pipefail

# Display step name
print_step() {
    figlet "$1"
}

# Update and install figlet
sudo apt update -y
sudo apt install -y figlet

print_step "Git Install"
sudo apt install -y git
git --version | figlet
sleep 10

print_step "Java Install"
sudo apt install -y openjdk-21-jdk
java -version 2>&1 | head -n 1 | figlet
sleep 10

print_step "Jenkins Install"
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
    sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y
sudo apt install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins

# Firewall setup (if ufw is enabled)
if sudo ufw status | grep -q inactive; then
    echo "UFW is inactive, skipping firewall setup"
else
    sudo ufw allow 8080
    sudo ufw status
fi

# Save Jenkins initial password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword | tee password.txt

print_step "AWS CLI Install"
sudo apt update -y
sudo apt install -y unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
aws --version | figlet
rm -rf awscliv2.zip aws

print_step "kubectl Install"
sudo apt-get update -y
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
rm kubectl

print_step "Docker Install"
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker

print_step "Docker Group"
sudo usermod -aG docker "$USER"
newgrp docker <<EONG
echo "Docker group updated for user: $USER"
EONG

print_step "Minikube Install"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

# Start Minikube
print_step "Minikube Start"
minikube start --driver=docker
minikube status
minikube addons enable ingress

# Deploy NGINX pod
print_step "Deploy NGINX"
kubectl run nginx-pod --image=nginx
sleep 10
kubectl get pods -w &
kubectl expose pod nginx-pod --port=80 --type=NodePort
