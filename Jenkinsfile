pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = '506115906214'
        AWS_REGION = 'ap-south-1'
        IMAGE_NAME = 'myimage'
        ECR_REPO_NAME = 'myapp'
        ECR_REPO_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}"
    }

    stages {
        stage('Checkout Code') {
           steps {
               git branch: 'main', url: 'https://github.com/venkat3534/git-cf-jenkins-ecr-ansible-ec2.git'
           }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }
        
        stage('Create ECR Repository (if not exists)') {
            steps {
                sh '''
                aws ecr describe-repositories --repository-names myapp --region $AWS_REGION || \
                aws ecr create-repository --repository-name myapp --region $AWS_REGION
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                sh 'aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO_URI'
            }
        }

        stage('Tag & Push Image to ECR') {
            steps {
                sh 'docker tag $IMAGE_NAME:latest $ECR_REPO_URI:latest'
                sh 'docker push $ECR_REPO_URI:latest'
            }
        }
    }
}
