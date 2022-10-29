pipeline {
    agent any
	tools {
        maven 'Maven 3.3.3'
    }
    stages {
		stage('Clean Up Workspace') {
            steps {
                echo 'Deleteing old workspace..'
				cleanWs()
            }
        }
		stage('SCM Checkout') {
            steps {
                echo 'Check out the code from Github..'
				git branch: 'integration', credentialsId: 'github_cred', url: 'https://github.com/pravrawa/maven-samples.git'
				
            }
        }
        stage('Build & SonarQube analysis') {
            steps {
                echo 'Building & Code Analysis..'
				withSonarQubeEnv('SonarQube') {
                sh 'mvn clean package sonar:sonar'
				}
            }
        }
		stage('JUnit Test Report') {
            steps {
                echo 'Publishing Junit Test reports..'
				junit allowEmptyResults: true, testResults: 'single-module/target/surefire-reports/**.xml'
                
            }
        }
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker Image..'
                sh 'docker build -t 10.80.0.241:8085/tycoon2506/sample-app:$BUILD_NUMBER .'
            }
        }
		stage('Push image to Nexus Repository ') {
            steps {
                 echo 'Uploading Docker Image to Nexus repository..'
				withDockerRegistry(credentialsId: 'nexus-cred', url: 'http://10.80.0.241:8085') {
				sh  'docker push 10.80.0.241:8085/tycoon2506/sample-app:$BUILD_NUMBER'
				}
		    
		    
		    
		    
				
            }
        }
		stage('Delete Tomcat Container') {
            steps {
				echo 'Deleting Tomcat Container..'
				sh 'docker stop tomcat-sample-webapp'
				sh 'docker rm tomcat-sample-webapp'
				
            }
        }
		stage('Run Docker container on Jenkins Agent') {
            steps {
                echo 'Running Tomcat Container..'
                sh 'docker run --name tomcat-sample-webapp -d -p 8090:8080 10.80.0.241:8085/tycoon2506/sample-app:$BUILD_NUMBER'
            }
        }
    }
}
