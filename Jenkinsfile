pipeline {
    agent any

    stages {
        stage('Cloning Github repo to Jenkins') {
            steps {
                script {
                    echo 'Cloning Github repo to Jenkins.......'
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-token', url: 'https://github.com/DzeDze/hotel-reservation-prediction.git']])
                }
            }
        }

        stage('Setting up Python environment and Installing dependencies') {
            steps {
                script {
                    echo 'Setting up Python environment and installing dependencies with uv...'
                    sh '''
                        uv sync --all-extras --dev
                    '''
                }
            }
        }
    }
}