pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        DOCKER_IMAGE_APP = "755952719952.dkr.ecr.eu-west-1.amazonaws.com/odh-vkg"
        DOCKER_TAG_APP = "prod-$BUILD_NUMBER"
        DOCKER_SERVICES = "app"
        DOCKER_SERVER_IP = "63.33.128.18"
        DOCKER_SERVER_DIRECTORY = "/var/docker/odh-vkg"
        DOCKER_SERVER_PORT = "1008"
        DOCKER_SERVER_PROJECT = "odh-vkg"
        ORIGINAL_POSTGRES_HOST = "prod-postgres-tourism.co90ybcr8iim.eu-west-1.rds.amazonaws.com"
        ORIGINAL_POSTGRES_DB = "tourism"
        ORIGINAL_POSTGRES_USERNAME = credentials('odh-vkg-prod-original-postgres-username')
        ORIGINAL_POSTGRES_PASSWORD = credentials('odh-vkg-prod-original-postgres-password')
        COPY_POSTGRES_HOST = "test-pg-bdp.co90ybcr8iim.eu-west-1.rds.amazonaws.com"
        COPY_POSTGRES_DB = "odh_vkg_prod"
        COPY_POSTGRES_USERNAME = credentials('odh-vkg-prod-copy-postgres-username')
        COPY_POSTGRES_PASSWORD = credentials('odh-vkg-prod-copy-postgres-password')
    }

    stages {
        stage('Configure') {
            steps {
                sh "cp .env.example .env"
                sh "echo 'DOCKER_IMAGE_APP=${DOCKER_IMAGE_APP}' >> .env"
                sh "echo 'DOCKER_TAG_APP=${DOCKER_TAG_APP}' >> .env"
                
                sh "echo 'ORIGINAL_POSTGRES_HOST=${ORIGINAL_POSTGRES_HOST}' >> .env"
                sh "echo 'ORIGINAL_POSTGRES_DB=${ORIGINAL_POSTGRES_DB}' >> .env"
                sh "echo 'ORIGINAL_POSTGRES_USERNAME=${ORIGINAL_POSTGRES_USERNAME}' >> .env"
                sh "echo 'ORIGINAL_POSTGRES_PASSWORD=${ORIGINAL_POSTGRES_PASSWORD}' >> .env"
                sh "echo 'COPY_POSTGRES_HOST=${COPY_POSTGRES_HOST}' >> .env"
                sh "echo 'COPY_POSTGRES_DB=${COPY_POSTGRES_DB}' >> .env"
                sh "echo 'COPY_POSTGRES_USERNAME=${COPY_POSTGRES_USERNAME}' >> .env"
                sh "echo 'COPY_POSTGRES_PASSWORD=${COPY_POSTGRES_PASSWORD}' >> .env"

                sh 'sed -i -e "s%\\(DOCKER_SERVER_PORT\\s*=\\).*\\$%\\1${DOCKER_SERVER_PORT}%" .env'

                sh 'sed -i -e "s%\\(jdbc.url\\s*=\\).*\\$%\\1jdbc\\\\\\\\:postgresql\\\\\\\\://${COPY_POSTGRES_HOST}/${COPY_POSTGRES_DB}%" vkg/odh.docker.properties'
                sh 'sed -i -e "s%\\(jdbc.user\\s*=\\).*\\$%\\1${COPY_POSTGRES_USERNAME}%" vkg/odh.docker.properties'
                sh 'sed -i -e "s%\\(jdbc.password\\s*=\\).*\\$%\\1${COPY_POSTGRES_PASSWORD}%" vkg/odh.docker.properties'
            }
        }
        stage('Build & Push') {
            steps {
                sh "aws ecr get-login --region eu-west-1 --no-include-email | bash"
                sh "docker-compose -f docker-compose.build.yml build --pull ${DOCKER_SERVICES}"
                sh "docker-compose -f docker-compose.build.yml push ${DOCKER_SERVICES}"
            }
        }
        stage('Deploy') {
            steps {
                sshagent(['jenkins-ssh-key']) {
                    sh """ssh -o StrictHostKeyChecking=no ${DOCKER_SERVER_IP} 'AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" bash -c "aws ecr get-login --region eu-west-1 --no-include-email | bash"'"""

                    sh "ssh -o StrictHostKeyChecking=no ${DOCKER_SERVER_IP} 'ls -1t ${DOCKER_SERVER_DIRECTORY}/releases/ | tail -n +10 | grep -v `readlink -f ${DOCKER_SERVER_DIRECTORY}/current | xargs basename --` -- | xargs -r printf \"${DOCKER_SERVER_DIRECTORY}/releases/%s\\n\" | xargs -r rm -rf --'"
                
                    sh "ssh -o StrictHostKeyChecking=no ${DOCKER_SERVER_IP} 'mkdir -p ${DOCKER_SERVER_DIRECTORY}/releases/${BUILD_NUMBER}'"
                    sh "pv docker-compose.run.yml | ssh -o StrictHostKeyChecking=no ${DOCKER_SERVER_IP} 'tee ${DOCKER_SERVER_DIRECTORY}/releases/${BUILD_NUMBER}/docker-compose.yml'"
                    sh "scp -r -o StrictHostKeyChecking=no .env ${DOCKER_SERVER_IP}:${DOCKER_SERVER_DIRECTORY}/releases/${BUILD_NUMBER}/.env"
                    sh "scp -r -o StrictHostKeyChecking=no vkg ${DOCKER_SERVER_IP}:${DOCKER_SERVER_DIRECTORY}/releases/${BUILD_NUMBER}/vkg"
                    sh "scp -r -o StrictHostKeyChecking=no jdbc ${DOCKER_SERVER_IP}:${DOCKER_SERVER_DIRECTORY}/releases/${BUILD_NUMBER}/jdbc"
                    sh "scp -r -o StrictHostKeyChecking=no src ${DOCKER_SERVER_IP}:${DOCKER_SERVER_DIRECTORY}/releases/${BUILD_NUMBER}/src"
                    sh "ssh -o StrictHostKeyChecking=no ${DOCKER_SERVER_IP} 'cd ${DOCKER_SERVER_DIRECTORY}/releases/${BUILD_NUMBER} && docker-compose pull'"

                    sh "ssh -o StrictHostKeyChecking=no ${DOCKER_SERVER_IP} '[ -d \"${DOCKER_SERVER_DIRECTORY}/current\" ] && (cd ${DOCKER_SERVER_DIRECTORY}/current && docker-compose down --project-name ${DOCKER_SERVER_PROJECT}) || true'"
                    sh "ssh -o StrictHostKeyChecking=no ${DOCKER_SERVER_IP} 'ln -sfn ${DOCKER_SERVER_DIRECTORY}/releases/${BUILD_NUMBER} ${DOCKER_SERVER_DIRECTORY}/current'"
                    sh "ssh -o StrictHostKeyChecking=no ${DOCKER_SERVER_IP} 'cd ${DOCKER_SERVER_DIRECTORY}/current && docker-compose up --project-name ${DOCKER_SERVER_PROJECT} --detach'"
                }
            }
	    }
    }
}
