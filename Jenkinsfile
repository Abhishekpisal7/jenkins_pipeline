pipeline {
    agent {
        label 'docker-maven-trivy'
    }

    tools {
        maven 'maven3'
    }

    environment {
        SONAR_IP = '172.31.19.204'
    }
    
    stages{
        stage("checkout"){
            steps{
                checkout scm
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
                org.sonarsource.scanner.maven:sonar-maven-plugin:sonar \
                -Dsonar.projectKey=cwvj-devsecops-demo \
                -Dsonar.host.url="http://${SONAR_IP}:9000" \
                -Dsonar.token="${SONAR_TOKEN}" \
                -Dsonar.qualityGate.wait=true'
                }
            }
        }
    }
}