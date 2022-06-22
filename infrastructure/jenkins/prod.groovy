pipeline {
    agent any

    environment {
        COMPOSE_PROJECT_NAME = "odh-vkg"
        DOCKER_IMAGE_ONTOP = "755952719952.dkr.ecr.eu-west-1.amazonaws.com/odh-vkg-ontop"
        DOCKER_IMAGE_NGINX = "755952719952.dkr.ecr.eu-west-1.amazonaws.com/odh-vkg-nginx"
        DOCKER_TAG = "prod-$BUILD_NUMBER"
        ANSIBLE_LIMIT = "prod"

        SERVER_PORT = "1008"
        ONTOP_QUERY_TIMEOUT = 15

        // VIRTUAL KNOWLEDGE GRAPH DB
        VKG_POSTGRES_HOST = "virtual-knowledge-graph.co90ybcr8iim.eu-west-1.rds.amazonaws.com"
        VKG_POSTGRES_DB = "vkg"
        VKG_POSTGRES_USER_READONLY = "ontopicreadonly"
        VKG_POSTGRES_PASSWORD_READONLY = credentials('it.bz.opendatahub.sparql.db.vkg.password.readonly')

        // Authentication proxy
        KEYCLOAK_REALM_URL = "https://auth.opendatahub.bz.it/auth/realms/noi"
        KEYCLOAK_DOMAIN_NAME = "auth.opendatahub.bz.it"
        KEYCLOAK_CLIENT_ID = "it.bz.opendatahub.sparql"
        KEYCLOAK_CLIENT_SECRET = credentials('it.bz.opendatahub.sparql.KEYCLOAK_CLIENT_SECRET')
        KEYCLOAK_ALLOWED_GROUPS = "/VKG Full Access"
        AUTH_PROXY_COOKIE_SECRET = credentials('it.bz.opendatahub.sparql.OAUTH2_COOKIE_SECRET')

		GOOGLE_ANALYTICS_ID = "G-W19M9ZYQT0"
    }

    stages {
        stage('Configure') {
            steps {
                sh '''
                    rm -f .env
                    echo "COMPOSE_PROJECT_NAME=${COMPOSE_PROJECT_NAME}" >> .env
                    echo "DOCKER_IMAGE_ONTOP=${DOCKER_IMAGE_ONTOP}" >> .env
                    echo "DOCKER_IMAGE_NGINX=${DOCKER_IMAGE_NGINX}" >> .env
                    echo "DOCKER_TAG=${DOCKER_TAG}" >> .env

                    echo "SERVER_PORT=${SERVER_PORT}" >> .env

                    echo "KEYCLOAK_REALM_URL=${KEYCLOAK_REALM_URL}" >> .env
                    echo "KEYCLOAK_DOMAIN_NAME=${KEYCLOAK_DOMAIN_NAME}" >> .env
                    echo "KEYCLOAK_CLIENT_ID=${KEYCLOAK_CLIENT_ID}" >> .env
                    echo "KEYCLOAK_CLIENT_SECRET=${KEYCLOAK_CLIENT_SECRET}" >> .env
                    echo "KEYCLOAK_ALLOWED_GROUPS=${KEYCLOAK_ALLOWED_GROUPS}" >> .env
                    echo "AUTH_PROXY_COOKIE_SECRET=${AUTH_PROXY_COOKIE_SECRET}" >> .env

                    sed -i -e "s%\\(jdbc.url\\s*=\\).*\\$%\\1jdbc\\\\\\\\:postgresql\\\\\\\\://${VKG_POSTGRES_HOST}/${VKG_POSTGRES_DB}%" vkg/odh.docker.properties
                    sed -i -e "s%\\(jdbc.user\\s*=\\).*\\$%\\1${VKG_POSTGRES_USER_READONLY}%" vkg/odh.docker.properties
                    sed -i -e "s%\\(jdbc.password\\s*=\\).*\\$%\\1${VKG_POSTGRES_PASSWORD_READONLY}%" vkg/odh.docker.properties
                    sed -i -e "s%\\(ontop.query.defaultTimeout\\s*=\\).*\\$%\\1${ONTOP_QUERY_TIMEOUT}%" vkg/odh.docker.properties

                    echo "GOOGLE_ANALYTICS_ID=${GOOGLE_ANALYTICS_ID}" > website/.env
                    (cd website/utils && ./dotenv-sed.sh)
                '''
            }
        }
        stage('Build') {
            steps {
                sh '''
                    aws ecr get-login --region eu-west-1 --no-include-email | bash
                    docker-compose --no-ansi -f infrastructure/docker-compose.build.yml build --pull
                    docker-compose --no-ansi -f infrastructure/docker-compose.build.yml push
                '''
            }
        }
        stage('Deploy') {
            steps {
               sshagent(['jenkins-ssh-key']) {
                    sh """
                        cd infrastructure/ansible
                        ansible-galaxy install -f -r requirements.yml
                        ansible-playbook --limit=${ANSIBLE_LIMIT} deploy.yml --extra-vars "release_name=${BUILD_NUMBER}"
                    """
                }
            }
        }
    }
}
