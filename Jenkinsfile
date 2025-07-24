pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-app-image"
        ECR_REPO = "506115906214.dkr.ecr.ap-south-1.amazonaws.com/myapp"
        AWS_REGION = "ap-south-1"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git 'https://github.com/venkat3534/git-cf-jenkins-ecr-ansible-ec2.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $IMAGE_NAME .'
                }
            }
        }

        stage('Tag & Push to ECR') {
            steps {
                script {
                    sh """
                        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                        docker tag $IMAGE_NAME:latest $ECR_REPO:latest
                        docker push $ECR_REPO:latest
                    """
                }
            }
        }

        stage('Deploy using Ansible') {
            steps {
                sh 'ansible-playbook -i inventory.ini deploy_app.yml'
            }
        }
    }
}
