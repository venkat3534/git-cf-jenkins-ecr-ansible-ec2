#!/bin/bash

set -e

echo "  Updating system packages..."
sudo yum update -y

echo " installing ansible package..."
sudo yum install ansible -y

echo " checking ansible version..."
sudo ansible --version

echo " Installing the amazon.aws collection, which provides Ansible modules and plugins for managing AWS resources..."
sudo ansible-galaxy collection install amazon.aws

echo " python is technology underlying runtime env of ansible..."
sudo yum install python3-pip -y

echo " Installing Python libraries for interacting with AWS services..."
sudo pip3 install boto3 botocore

echo " Installing Docker..."
sudo yum install -y docker

echo " Starting and enabling Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo " Adding ec2-user to docker group..."
sudo usermod -aG docker ec2-user

echo " Pulling Jenkins LTS image..."
sudo docker pull jenkins/jenkins:lts

echo " Running Jenkins container..."
sudo docker run -d \
   --name jenkins \
   -p 8080:8080 \
   -p 50000:50000 \
   -v /var/jenkins_home:/var/jenkins_home \
   -v /var/run/docker.sock:/var/run/docker.sock \
   jenkins/jenkins:lts

echo " Waiting 30 seconds for Jenkins to initialize..."
sleep 30
echo " Currently running containers..."
sudo docker ps -a

# Get public IP using external service
PUBLIC_IP=$(curl -s ifconfig.io)

# Print Jenkins access details in green
echo -e "\e[32mJenkins URL: http://$PUBLIC_IP:8080\e[0m"
echo -e "\e[32mInitial Admin Password: $(sudo docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword)\e[0m"
