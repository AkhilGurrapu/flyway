pipeline {
    agent any
    
    stages {
        stage('Verify version') {
            steps {
                        sh 'docker run --rm flyway/flyway:8.5.1 version'
                    }
        }
        stage('migrate') {
            steps {
                sh 'docker run --rm -v $WORKSPACE/db:/flyway/db -v $WORKSPACE/conf:/flyway/conf flyway/flyway:8.5.1 -user=$snowflake-user -password=$snowflake-password migrate'
            }
    }
    }
    
    post {
        failure {
            echo 'Migration failed!'
        }
    }
}