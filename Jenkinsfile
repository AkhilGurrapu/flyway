pipeline {
    agent any
    
    stages {
        stage('Flyway Migration') {
            steps {
                script {
                    // Set up Flyway configuration
                    withCredentials([string(credentialsId: 'snowflake-password', variable: 'SNOWFLAKE_PASSWORD')]) {
                        sh """
                        flyway -url="jdbc:snowflake://TVDWARH-WSB57083.snowflakecomputing.com" \
                        -user=<'akhilgurrapu' \
                        -password=\$SNOWFLAKE_PASSWORD \
                        -locations=filesystem:/var/lib/jenkins/workspace/Flyway/FlywayPL/DB \
                        migrate
                        """
                    }
                }
            }
        }
    }
}