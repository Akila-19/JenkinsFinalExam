pipeline {
    agent any
    stages{
        stage('code'){
            steps{
                git url: 'https://github.com/Akila-19/JenkinsFinalExam.git', branch: 'main'
            }
        }
        stage('Build'){
            steps{
                docker.build('healthcare:latest')
            }
        }
        stage('Test'){
            steps{
                echo "Testing"
            }
        }
        stage('Deploy'){
           script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        // Push Docker image to Docker Hub
                        docker.image('healthcare:latest').push()
                    }
        }
    }
}
