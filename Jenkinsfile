pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    dir('/home/RaghuWork/AutomaticBooking') {
                        git branch: 'main', credentialsId: 'Git - RaghavendraP', url: 'https://github.com/RaghavendraPrabhu/AutomaticBooking.git'
                    }
                }
            }
        }
        
        stage('BMD Site Up') {
            steps {
                script {
                    dir('/home/RaghuWork/BMD') {
                        sh 'docker-compose up -d'
                        sh 'sleep 5'
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
                        sh 'sleep 5'
                    }
                }
            }
        }
        
        stage('BMD Site Down') {
            steps {
                script {
                    dir('/home/RaghuWork/BMD') {
                        sh 'docker-compose down'
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                def buildSuccess = currentBuild.result == 'SUCCESS'
                sendEmailNotification(buildSuccess)
            }
        }
    }
}

def sendEmailNotification(isSuccess) {
    dir('/home/RaghuWork/AutomaticBooking') {
        def status = isSuccess ? "Successful 😊" : "Failed 😢"
        def color = isSuccess ? "Green" : "Red"

        emailext attachLog: false,
            subject: "BMD Seat Booking Done",
            to: 'raghavendrap@siddhatech.com,ankital@siddhatech.com',
            body: """Hi Guys,</br>
</br>
BMD Seat Booking Done For Monday / Tuesday / Wednesday
</br>
</br>
Thanks & Regards,</br>
Raghavendra Uday Prabhu</br>""",
            compressLog: true
    }
}
