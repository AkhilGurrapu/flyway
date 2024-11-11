pipeline {
    agent any
    
    stages {
        stage('Verify version') {
            steps {
                        sh 'docker run --rm flyway/flyway:8.5.1 version'
                    }
        }
        stage('Run Migration') {
            steps {
                sh 'flyway -configFiles=flyway.conf migrate'
    }
}
    }
    
    post {
        failure {
            echo 'Migration failed!'
        }
    }
}