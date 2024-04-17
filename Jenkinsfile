pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'akila1908/healthcarejenkinsapp' // Modify this according to your Docker repository
    }
    
    stages {
        stage('Build') {
            steps {
                // Build Docker image and tag it
                sh 'docker build -t finalexam .'
                sh 'docker tag finalexam $DOCKER_IMAGE'
            }
        }
        stage('Deploy') {
            steps {
                // Login to Docker registry
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin docker.io"
                    // Push Docker image to registry
                    sh 'docker push $DOCKER_IMAGE'
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                // Use SSH to connect to your EC2 instance and run the Docker image
                script {
                    // Define the SSH credentials ID configured in Jenkins
                    def sshCredentials = '07a6bae1-fe74-47c2-9080-02e42194cdbb'

                    // Define your EC2 instance details
                    def ec2Instance = 'ec2-52-201-222-132.compute-1.amazonaws.com'
                    def ec2Username = 'ubuntu' // or any other username depending on your EC2 instance configuration

                    // Define your Docker image details
                    def dockerImage = 'akila1908/healthcarejenkinsapp:latest'

                    // Run the SSH command to pull and run the Docker image
                    sshagent(credentials: [sshCredentials]) {
                        sh "ssh ${ec2Username}@${ec2Instance} 'docker pull ${dockerImage} && docker run -d -p 8080:80 ${dockerImage}'"
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

