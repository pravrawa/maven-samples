pipeline {
    agent any
	tools {
        maven 'Maven 3.3.3'
    }
    stages {
		stage('Clean Up Workspace') {
            steps {
                echo 'Deleteing old workspace...'
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
                sh 'docker build -t nexus-demo:8085/tycoon2506/sample-app:$BUILD_NUMBER .'
            }
        }
		stage('Push image to Nexus Repository ') {
            steps {
                 echo 'Uploading Docker Image to Nexus repository..'
		//		withDockerRegistry(credentialsId: 'nexus-cred', url: 'http://172.31.6.126:8085') {
		//		sh  'docker push 172.31.6.126:8085/tycoon2506/sample-app:$BUILD_NUMBER'
		//		}
				
            }
        }
		stage('Delete Tomcat Container') {
            steps {
				if    	[[ $(docker ps | grep ':8090') = *tomcat-sample-webapp* ]]; then
		echo "Found a Tomcat Container, Deleting it!"
		docker stop tomcat-sample-webapp
		docker rm tomcat-sample-webapp
else
		echo "Will run Tomcat Container in next stage"
   
fi
				
            }
        }
		stage('Run Docker container on Jenkins Agent') {
            steps {
                echo 'Running Tomcat Container..'
                sh 'docker run --name tomcat-sample-webapp -d -p 8090:8080 172.31.6.126:8085/tycoon2506/sample-app:$BUILD_NUMBER'
            }
        }
    }
}
