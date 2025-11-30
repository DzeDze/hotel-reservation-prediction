pipeline {
    agent any

    environment {
        GCP_PROJECT = "flash-spot-479504-u3" //copy from gcp console
        GCLOUD_PATH = "/var/jenkins_home/google-cloud-sdk/bin"
    }

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

        stage('Building and Pushing Docker Image to GCR') {
            steps {
                withCredentials([file(credentialsId: 'gcp-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    script {
                        echo 'Building and Pushing Docker Image to GCR.......'
                        sh '''
                            export PATH=$PATH:$GCLOUD_PATH
                            gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}
                            gcloud config set project ${GCP_PROJECT}
                            gcloud auth configure-docker --quiet
                            IMAGE_NAME=gcr.io/${GCP_PROJECT}/hotel-reservation-prediction:latest
                            docker build -t ${IMAGE_NAME} .
                            docker push ${IMAGE_NAME}
                        '''
                    }
                } 
            }
        }

        stage('Deploy to Google Cloud Run'){
            steps{
                withCredentials([file(credentialsId: 'gcp-key' , variable : 'GOOGLE_APPLICATION_CREDENTIALS')]){
                    script{
                        echo 'Deploy to Google Cloud Run.............'
                        sh '''
                        export PATH=$PATH:${GCLOUD_PATH}


                        gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}

                        gcloud config set project ${GCP_PROJECT}

                        gcloud run deploy hotel-reservation-prediction \
                            --image=gcr.io/${GCP_PROJECT}/hotel-reservation-prediction:latest \
                            --platform=managed \
                            --region=us-central1 \
                            --allow-unauthenticated
                            
                        '''
                    }
                }
            }
        }
    }
}