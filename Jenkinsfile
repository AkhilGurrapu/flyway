pipeline {
    agent any
    
    stages {
        stage('Setup') {
            steps {
                sh '''
                    wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/9.22.3/flyway-commandline-9.22.3-linux-x64.tar.gz | tar xvz
                    export PATH=$PATH:`pwd`/flyway-9.22.3
                '''
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