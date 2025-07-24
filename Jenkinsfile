pipeline {
    agent any

    environment {
        STACK_NAME = "my-ec2-stack"
        REGION = "ap-south-1"
        TEMPLATE_FILE = "ec2-setup.yaml"
        INSTALL_SCRIPT = "setup-jenkins-ansible.sh"
        KEY_NAME = "gvr"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out code..."
                checkout scm
            }
        }

        stage('Deploy EC2 Stack') {
            steps {
                echo "Deploying EC2 using CloudFormation"
                sh """
                aws cloudformation deploy \
                  --stack-name ${STACK_NAME} \
                  --template-file ${TEMPLATE_FILE} \
                  --capabilities CAPABILITY_NAMED_IAM \
                  --parameter-overrides KeyName=${KEY_NAME} \
                  --region ${REGION}
                """
            }
        }

        stage('Get Jenkins EC2 IP') {
            steps {
                script {
                    def output = sh(script: """
                        aws ec2 describe-instances \
                          --filters "Name=tag:Name,Values=CICD-Server" \
                          --query "Reservations[*].Instances[*].PublicIpAddress" \
                          --region ${REGION} \
                          --output text
                    """, returnStdout: true).trim()

                    env.JENKINS_IP = output
                    echo "Jenkins EC2 IP: ${env.JENKINS_IP}"
                }
            }
        }

        stage('Install Jenkins & Ansible') {
            steps {
                echo "Installing Jenkins and Ansible on Jenkins EC2"
                sh """
                chmod +x ${INSTALL_SCRIPT}
                ssh -o StrictHostKeyChecking=no -i ~/.ssh/${KEY_NAME}.pem ec2-user@${env.JENKINS_IP} 'bash -s' < ${INSTALL_SCRIPT}
                """
            }
        }
    }

    post {
        success {
            echo "✅ Infrastructure & Jenkins setup complete!"
        }
        failure {
            echo "❌ Pipeline failed. Check logs for more details."
        }
    }
}
