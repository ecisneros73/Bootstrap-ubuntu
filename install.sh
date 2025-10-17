#!/bin/bash
# Jenkins install

#Install utilities
sudo apt update
sudo apt install figlet
git  --version 2>&1 | head -n 1 | figlet

sleep 60


figlet Install git 
sudo apt install git -y
git --version


figlet Java Install

sudo apt install openjdk-21-jdk -y
java -version 2>&1 | head -n 1 | figlet
sleep 30

figlet Install Jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install jenkins -y
sudo systemctl status jenkins

# Allow Jenkins to communicate by setting up the default UFW firewall:

sudo ufw allow 8080
sudo ufw status

# Jenkins password 
sudo cat /var/lib/jenkins/secrets/initialAdminPassword >> password.txt



#AWS CLI Install 
sudo apt update
sudo apt install -y unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install 
aws --version 2>&1 | head -n 1 | figlet


#kubectl Install
sudo apt-get update -y
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x ./kubectl    
sudo mv ./kubectl /usr/local/bin/kubectl     
kubectl version --client


#Docker install

sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER # Add your user to the docker group to run docker commands without sudo
newgrp docker # Activate the changes immediately, or log out and back in

sleep 60

figlet Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64



# Minikube start
minikube start --driver=docker
minikube status
minikube addons enable ingress


#deploy nginx pod
sleep 60
kubectl run nginx-pod --image nginx
kubectl get pod -w
kubectl expose pod nginx-pod --port 80 --type NodePort