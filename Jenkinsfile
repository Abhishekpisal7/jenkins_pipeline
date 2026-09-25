pipeline {
    agent {
        label 'docker-maven-trivy'
    }

    tools {
        maven 'maven3'
    }

    environment {
        SONAR_IP = '172.31.19.204'
        ECR_REGISTRY = '565122145290.dkr.ecr.us-east-1.amazonaws.com'
        IMAGE_REPO = "${ECR_REGISTRY}/devsecops-demo"
    }
    
    stages{
        stage("checkout"){
            steps{
                checkout scm
                sh 'pwd'
            }
        }

        stage("Trivey FS Scan"){
            steps{
                sh 'trivy fs --exit-code 1 --severity HIGH,CRITICAL .'
            }
        }

        stage("Build and Sonar"){
            steps{
                withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONAR_TOKEN')]) {
                sh 'mvn  -f java-maven/pom.xml clean verify \
                org.sonarsource.scanner.maven:sonar-maven-plugin:5.4.0.6343:sonar \
                -Dsonar.projectKey=cwvj-devsecops-demo \
                -Dsonar.host.url="http://${SONAR_IP}:9000" \
                -Dsonar.token="${SONAR_TOKEN}" \
                -Dsonar.qualitygate.wait=true'
                }
            }
        }

        stage("ECR Login") {
            steps {
                sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ECR_REGISTRY}'
            }
        }

        stage("Image Build") {
            steps {
                sh 'docker build --platform linux/amd64 -t "$IMAGE_REPO:$BUILD_NUMBER" -t "$IMAGE_REPO:latest" .'
            }
        }

        stage("Trivy Image Scan") {
            steps {
                sh 'trivy image --exit-code --severity HIGH,CRITICAL "$IMAGE_REPO:$BUILD_NUMBER"'
            }
        }
    }
}