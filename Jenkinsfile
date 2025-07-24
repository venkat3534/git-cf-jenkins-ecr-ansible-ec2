pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        DOCKER_IMAGE = 'venkat/myapp:latest'
        ECR_REPO = 'myapp'
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                cd docker
                docker build -t ${DOCKER_IMAGE} .
                """
            }
        }

        stage('Push Image to ECR') {
            steps {
                script {
                    def accountId = sh(script: "aws sts get-caller-identity --query Account --output text", returnStdout: true).trim()
                    def ecrUrl = "${accountId}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"

                    sh """
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ecrUrl}
                    docker tag ${DOCKER_IMAGE} ${ecrUrl}
                    docker push ${ecrUrl}
                    """
                }
            }
        }

        stage('Deploy to App EC2') {
            steps {
                sh """
                chmod +x app-deploy.sh
                ssh -o StrictHostKeyChecking=no -i ~/.ssh/${KEY_NAME}.pem ec2-user@${APP_IP} 'bash -s' < app-deploy.sh
                """
            }
        }
    }

    post {
        success {
            echo "✅ Full setup completed successfully!"
        }
        failure {
            echo "❌ Something went wrong. Check the logs."
        }
    }
}
