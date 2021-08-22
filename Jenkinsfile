pipeline {
    agent any
	tools {
        maven 'Maven 3.3.3'
        //jdk 'jdk11'
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
				//echo "${env.BRANCH_NAME}"
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
		stage('Quality Gate') {
            steps {
                echo 'Waiting for Quality Gate results..'
				//timeout(time: 1, unit: 'MINUTES') {
                //waitForQualityGate abortPipeline: false
                //}
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker Image..'
                sh 'docker build -t tycoon2506/sample-app:$BUILD_NUMBER .'
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
                sh 'docker run --name tomcat-sample-webapp -d -p 8090:8080 tycoon2506/sample-app:$BUILD_NUMBER'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying..'
                
            }
        }
    }
}
