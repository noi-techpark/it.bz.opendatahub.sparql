pipeline {
    agent any

    environment {
        DOCKER_IMAGE_APP = "app"
        DOCKER_TAG_APP = "latest"
    }

    stages {
        stage('Configure') {
            steps {
                sh "cp .env.example .env"
                sh "echo 'DOCKER_IMAGE_APP=${DOCKER_IMAGE_APP}' >> .env"
                sh "echo 'DOCKER_TAG_APP=${DOCKER_TAG_APP}' >> .env"
            }
        }
        stage('Test & Build') {
            steps {
                sh "docker-compose -f docker-compose.build.yml build --pull"
            }
        }
    }
    post { 
        always { 
            sh 'docker-compose -f docker-compose.build.yml down || true'
        }
    }
}
