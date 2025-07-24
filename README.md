# 🚀 Ansible + AWS EC2 & S3 + Jenkins CI/CD Automation

This repository demonstrates how to automate the creation of an AWS EC2 Instance and S3 bucket using **Ansible**, managed through a **Jenkins CI/CD pipeline**, with infrastructure defined as code.

---

## 🔧 Tech Stack
- 🧰 Ansible
- ☁️ Amazon Web Services (S3)
- 🚀 AWS EC2 Instance
- 🛠️ Jenkins
- 🗃️ GitHub (SCM)

---

## 📌 Objective

✅ Automate the creation of an AWS S3 bucket and AWS EC2 Instance
✅ Store Ansible playbooks in GitHub  
✅ Trigger a Jenkins CI/CD job to deploy the playbook  
✅ Use Jenkins IAM Role for secure AWS access  

---

## 🔧 Project Setup Overview

- EC2 instance is launched to act as the Jenkins master and Ansible control node.
- Jenkins is deployed using Docker via `Docker-Jenkins-InitialAdminPassword.sh`.
- Ansible is installed and configured with AWS credentials for infrastructure automation.
- Jenkins pipelines (for EC2 and S3 provisioning) are defined using Jenkinsfiles and run on this EC2 instance as a slave node.

---

## ✅ Prerequisites

- AWS IAM user with EC2 & S3 full access for AWS Access Keys.
- Proper AWS credentials are configured on the EC2 instance.
- Jenkins Docker container running.
- Ansible and Boto3 installed on the EC2 instance:

---

## 🚀 EC2 Jenkins Setup

1. Launch a new EC2 instance (Amazon Linux preferred).
2. Connect via SSH and run:

```bash
sudo chmod +x Docker-Jenkin-InitailAdminPassword.sh
sudo ./Docker-Jenkin-InitailAdminPassword.sh
```
   
3. Jenkins will be accessible at http://<EC2_Public_IP>:8080

---

## 🧰 Ansible & AWS Configuration

**Install Ansible on the Same EC2 Instance:**

```bash
sudo yum update
sudo yum upgrade -y
sudo yum install ansible -y
sudo ansible --version
sudo ansible-galaxy collection install amazon.aws
sudo ansible-galaxy collection list | grep "amazon.aws"
sudo yum install python3-pip -y
sudo pip3 install boto3 botocore -y
```

**Configure AWS credentials:**

```bash
aws configure
```

---

## 🛠️ Slave Node Configuration

Jenkins is configured to use the same EC2 instance as a slave.

- **Label**: `ansible-node`  
- **Remote root directory**: `/home/ec2-user/jenkins/`  
- **Launch method**: SSH with `ec2-user` credentials  

### Ensure Java is installed

Run the following command in the EC2 instance to install Java:

```bash
sudo yum install java-24-amazon-corretto-devel.x86_64
```
---

## 🔄 Jenkins Pipeline Configuration

1. **Create Jenkins Jobs** for each pipeline.

2. In each job configuration:

   - Select **Pipeline** as the project type.

   - Under **Pipeline Script from SCM**:
     - **SCM**: Git
     - **Repository URL**: `https://github.com/yaswanth00369/ansible-aws-ec2-s3-jenkins-cicd`
     - **Script Path**:
       - For EC2 provisioning: `Jenkinsfile-ansible-aws-ec2`
       - For S3 bucket creation: `Jenkinsfile-ansible-aws-s3`
       
---

## Docker Container (Jenkins) Details

```bash
docker ps
```

<img width="1299" height="171" alt="image" src="https://github.com/user-attachments/assets/632b3193-10ce-406d-bd22-e301ea9c2860" />

---

## Accessing Jenkins Server

http://15.207.86.118:8080/

<img width="1299" height="736" alt="image" src="https://github.com/user-attachments/assets/3acdc617-4026-4c60-a628-dcae89aaa5b5" />

---

## Jenkins Jobs

<img width="1299" height="736" alt="image" src="https://github.com/user-attachments/assets/a48ea4c4-3182-4a25-b9c8-489d37979f92" />

## S3 Build Details

<img width="1299" height="736" alt="image" src="https://github.com/user-attachments/assets/14a6f70d-2f9b-494a-ae6d-8a622b987322" />

<img width="1299" height="736" alt="image" src="https://github.com/user-attachments/assets/6db2cf58-86d4-4832-8182-062595e3150a" />

## EC2 Build Details

<img width="1299" height="736" alt="image" src="https://github.com/user-attachments/assets/d7429944-b76d-450a-9a56-2504ddf7f27e" />

<img width="1299" height="736" alt="image" src="https://github.com/user-attachments/assets/5dfa226f-d40f-41b1-b2d5-5954e65f97f0" />

---
