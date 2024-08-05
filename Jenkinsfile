pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    dir('/home/RaghuWork') {
                        git branch: 'development', credentialsId: 'Git - RaghavendraP', url: 'https://github.com/RaghavendraPrabhu/AutomaticBooking.git'
                    }
                }
            }
        }

        stage('Prepare Script') {
            steps {
                script {
                    dir('/home/RaghuWork/AutomaticBooking') {
                        sh 'chmod +x bmd.sh'
                    }
                }
            }
        }

        stage('Execute Script') {
            steps {
                script {
                    dir('/home/RaghuWork/AutomaticBooking') {
                        sh './bmd.sh'
                    }
                }
            }
        }
    }
}
