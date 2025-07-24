pipeline {
    agent any

    environment {
        ECR_REPO = '506115906214.dkr.ecr.ap-south-1.amazonaws.com/myapp:latest'
        IMAGE_NAME = 'myapp'
        AWS_REGION = 'ap-south-1'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/venkat3534/git-cf-jenkins-ecr-ansible-ec2.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Login to ECR') {
            steps {
                sh 'aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO'
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh 'docker tag $IMAGE_NAME:latest $ECR_REPO/$IMAGE_NAME:latest'
                sh 'docker push $ECR_REPO/$IMAGE_NAME:latest'
            }
        }

        stage('Deploy with Ansible') {
            steps {
                sh 'ansible-playbook -i hosts deploy_app.yml'
            }
        }
    }
}
