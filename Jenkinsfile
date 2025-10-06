pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = "saeid1993/sep01-project"
        DOCKER_CREDENTIALS_ID = "Docker_Hub"
    }

    stages {

        stage('Build') {
            tools {
                maven 'MAVEN_HOME'
            }
            steps {
                bat "mvn clean package -DskipTests"
            }
        }


        stage('Test') {
            tools {
                maven 'MAVEN_HOME'
            }
            steps {

                bat "mvn test"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image: ${DOCKER_IMAGE_NAME}"

                    docker.build(DOCKER_IMAGE_NAME)
                }
            }
        }


        stage('Push Docker Image') {
            when {
                branch 'main'
            }
            steps {
                script {
                    echo "Pushing Docker image to Docker Hub..."
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        docker.image(DOCKER_IMAGE_NAME).push("latest")
                    }
                }
            }
        }
    }


    post {
        always {
            junit '**/target/surefire-reports/*.xml'


            jacoco execPattern: 'target/jacoco.exec', classPattern: '**/target/classes', sourcePattern: '**/src/main/java'


            cleanWs()
        }
    }
}
