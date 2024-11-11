pipeline {
    agent any
    
    environment {
        // Create environment variables for Snowflake credentials
        SNOWFLAKE_USER = credentials('snowflake-user')
        SNOWFLAKE_PASSWORD = credentials('snowflake-password')
    }
    
    stages {
        stage('Run Migration') {
            steps {
                // Run Flyway using existing config
                sh 'flyway -configFiles=flyway.conf migrate'
            }
        }
    }
    
    post {
        success {
            echo "Migration completed successfully!"
        }
        failure {
            echo "Migration failed!"
        }
    }
}