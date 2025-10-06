pipeline {
    // Run on any available agent
    agent any

    // Define environment variables for the pipeline
    environment {
        // CORRECTED: Using the repository name with a hyphen
        DOCKER_IMAGE_NAME = "saeid1993/sep01-project" 
        DOCKER_CREDENTIALS_ID = "Docker_Hub"
    }

    stages {
        // Stage 1: Build the project and create the "fat JAR"
        stage('Build') {
            tools {
                // CORRECTED: Using the Maven tool name you specified
                maven 'MAVEN_HOME'
            }
            steps {
                // Use 'bat' for Windows. This command cleans, compiles, and packages the code
                // into a fat JAR, but skips running the tests for this stage.
                bat "mvn clean package -DskipTests"
            }
        }

        // Stage 2: Run the tests
        stage('Test') {
            tools {
                // CORRECTED: Using the Maven tool name you specified
                maven 'MAVEN_HOME'
            }
            steps {
                // Use 'bat' for Windows. This command runs the tests and generates
                // the JaCoCo code coverage data.
                bat "mvn test"
            }
        }

        // Stage 3: Build the Docker image
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image: ${DOCKER_IMAGE_NAME}"
                    // Build the image using the Dockerfile in the current directory
                    docker.build(DOCKER_IMAGE_NAME)
                }
            }
        }

        // Stage 4: Push the Docker image to Docker Hub
        stage('Push Docker Image') {
            // This stage will only run if the build is on the 'main' branch
            when {
                branch 'main'
            }
            steps {
                script {
                    echo "Pushing Docker image to Docker Hub..."
                    // Use the credentials configured in Jenkins to log in and push
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        docker.image(DOCKER_IMAGE_NAME).push("latest")
                    }
                }
            }
        }
    }

    // Post-build actions: This block runs after all stages are complete
    post {
        // 'always' means these steps will run regardless of whether the pipeline succeeded or failed
        always {
            // Step 1: Process JUnit test results
            junit '**/target/surefire-reports/*.xml'

            // Step 2: Process JaCoCo code coverage results
            jacoco execPattern: 'target/jacoco.exec', classPattern: '**/target/classes', sourcePattern: '**/src/main/java'

            // Step 3: Clean up the workspace
            cleanWs()
        }
    }
}
