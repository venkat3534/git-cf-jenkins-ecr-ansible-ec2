pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        STACK_NAME = 'Ec2-jenkins-stack'
        KEY_NAME = 'gvr'
        TEMPLATE_FILE = 'infra.yaml'
        JENKINS_INSTALL_SCRIPT = 'install-jenkins.sh'
        DOCKER_IMAGE = 'venkat/myapp:latest'
        ECR_REPO = 'myapp'
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Create EC2 Infrastructure') {
            steps {
                script {
                    sh """
                    aws cloudformation deploy \
                        --template-file ${TEMPLATE_FILE} \
                        --stack-name ${STACK_NAME} \
                        --parameter-overrides KeyName=${KEY_NAME} \
                        --region ${AWS_REGION} \
                        --capabilities CAPABILITY_NAMED_IAM
                    """
                }
            }
        }

        stage('Get Public IPs of EC2s') {
            steps {
                script {
                    // Get AppEC2 and CICDEC2 instance IPs
                    env.APP_IP = sh(script: '''
                        aws ec2 describe-instances \
                          --filters "Name=tag:Name,Values=App-Server" \
                          --query "Reservations[*].Instances[*].PublicIpAddress" \
                          --output text --region ${AWS_REGION}
                    ''', returnStdout: true).trim()

                    env.JENKINS_IP = sh(script: '''
                        aws ec2 describe-instances \
                          --filters "Name=tag:Name,Values=CICD-Server" \
                          --query "Reservations[*].Instances[*].PublicIpAddress" \
                          --output text --region ${AWS_REGION}
                    ''', returnStdout: true).trim()
                }
            }
        }

        stage('Install Jenkins and Ansible') {
            steps {
                sh """
                chmod +x ${JENKINS_INSTALL_SCRIPT}
                ssh -o StrictHostKeyChecking=no -i ~/.ssh/${KEY_NAME}.pem ec2-user@${JENKINS_IP} 'bash -s' < ${JENKINS_INSTALL_SCRIPT}
                """
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
