#!/bin/bash
# Jenkins install

# Java Install
java -version
sudo apt update
sudo apt install openjdk-21-jdk -y

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins

sudo apt update
sudo apt install jenkins -y
sudo systemctl status jenkins

# Allow Jenkins to communicate by setting up the default UFW firewall:

sudo ufw allow 8080

sudo ufw status

# Jnekins password 

sudo cat /var/lib/jenkins/secrets/initialAdminPassword


#AWS CLI Install 
sudo apt update
sudo apt install -y unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install




