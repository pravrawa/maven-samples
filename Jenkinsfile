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
				git credentialsId: 'github_cred', url: 'https://github.com/pravrawa/maven-samples.git'
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
                echo 'Building Docker Image...'
                //sh 'docker build -t tycoon2506/sample-app:1.1.0 .'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                
            }
        }
    }
}
