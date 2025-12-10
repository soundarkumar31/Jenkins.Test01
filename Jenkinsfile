pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'soundar/myapp'
        DOCKER_CONTAINER_NAME = 'myapp-container'
        DOCKER_HUB_IMAGE_NAME = 'soundarkumar31/myapp'
        TEST_CASE_RUN_BRANCH_NAME = 'master'
    }

    stages {

        stage('Git Clone') {
            steps {
                git credentialsId: 'soundarkumar31_jenkins_test', 
                    url: 'https://github.com/soundarkumar31/Jenkins.Test01.git'
            }
        }

        stage('Run Tests') {
            when {
                expression {
                    return env.TEST_CASE_RUN_BRANCH_NAME == env.BRANCH_NAME
                }
            }
            steps {
                bat 'dotnet test Jenkins.Test01.Tests --logger "trx;LogFileName=testResults.trx"'
            }
        }

        stage('Docker image Build') {
            steps {
                bat "docker build -t ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} ."
                bat "echo docker build succeed - %DOCKER_IMAGE_NAME%"
            }
        }

        stage('Docker old container remove') {
            steps {
                bat "docker rm -f ${DOCKER_CONTAINER_NAME} || echo No container"
            }
        }

        stage('Docker new container run') {
            steps {
                bat "docker run -d --name ${DOCKER_CONTAINER_NAME} ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }

        //----------------------------
        // NEW: Docker Push
        //----------------------------
        stage('Push Docker Image to Hub') {
             when {
                expression {
                    return env.TEST_CASE_RUN_BRANCH_NAME == 'prod'
                }
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub_cred',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {

                    bat "docker login -u %DOCKER_USER% -p %DOCKER_PASS%"
                    bat "docker tag ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_HUB_IMAGE_NAME}:${BUILD_NUMBER}"
                    bat "docker push ${DOCKER_HUB_IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }

    }

    post {
        always {
            echo "Pipeline Completed"
        }
    }
}
