pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'akila1908/healthcarejenkinsapp' // Modify this according to your Docker repository
        EC2_INSTANCE = 'ec2-52-201-222-132.compute-1.amazonaws.com'
        EC2_USER = 'ubuntu' // or any other username depending on your EC2 instance configuration
    }
    
    stages {
        stage('Build') {
            steps {
                // Build Docker image and tag it
                sh 'docker build -t healthcare-app .'
                sh 'docker tag healthcare-app $DOCKER_IMAGE'
            }
        }
        stage('Deploy') {
            steps {
                // Cleanup existing containers
                script {
                    sshagent(credentials: ['07a6bae1-fe74-47c2-9080-02e42194cdbb']) {
                        try {
                            ssh "ubuntu@${EC2_INSTANCE} \"docker stop \$(docker ps -q --filter ancestor=${DOCKER_IMAGE}) || true\""
                            ssh "ubuntu@${EC2_INSTANCE} \"docker rm \$(docker ps -aq --filter ancestor=${DOCKER_IMAGE}) || true\""
                        } catch (Exception e) {
                            echo "Error cleaning up containers: ${e}"
                        }
                    }
                }
                // Deploy Docker image to EC2 instance
                script {
                    sshagent(credentials: ['07a6bae1-fe74-47c2-9080-02e42194cdbb']) {
                        try {
                            ssh "ubuntu@${EC2_INSTANCE} \"docker pull ${DOCKER_IMAGE}\""
                            ssh "ubuntu@${EC2_INSTANCE} \"docker run -d -p 8081:80 ${DOCKER_IMAGE}\""
                        } catch (Exception e) {
                            echo "Error deploying Docker image: ${e}"
                        }
                    }
                }
            }
        }
    }
    
    post {
        always {
            // Logout from Docker registry
            sh 'docker logout'
        }
    }
}
