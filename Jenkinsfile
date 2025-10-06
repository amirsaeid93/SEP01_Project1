pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = "saeid1993/sep01-project"
        DOCKER_CREDENTIALS_ID = "Docker_Hub"
    }

    tools {
        maven 'MAVEN_HOME'
    }

    stages {

        stage('Build') {
            steps {
                echo "Building the project..."
                bat "mvn clean package -DskipTests"
            }
        }

        stage('Test') {
            steps {
                echo "Running unit tests..."
                bat "mvn test"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image: ${DOCKER_IMAGE_NAME}"
                    // Tag image with both build number and 'latest'
                    dockerImage = docker.build("${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}")
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
                        dockerImage.push("latest")
                        dockerImage.push("${env.BUILD_NUMBER}")
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Publishing test and coverage reports..."
            junit '**/target/surefire-reports/*.xml'

            jacoco(
                execPattern: 'target/jacoco.exec',
                classPattern: '**/target/classes',
                sourcePattern: '**/src/main/java'
            )

            echo "Cleaning workspace..."
            cleanWs()
        }

        success {
            echo "✅ Build and Docker image creation completed successfully!"
        }

        failure {
            echo "❌ Build failed. Please check the logs above."
        }
    }
}
