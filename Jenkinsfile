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
                // Download and setup Flyway
                sh '''
                    wget https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/9.8.1/flyway-commandline-9.8.1.tar.gz
                    tar -xzf flyway-commandline-9.8.1.tar.gz
                    
                    # Download Snowflake JDBC driver
                    wget https://repo1.maven.org/maven2/net/snowflake/snowflake-jdbc/3.13.30/snowflake-jdbc-3.13.30.jar
                    mv snowflake-jdbc-3.13.30.jar flyway-9.8.1/drivers/
                '''
                
                // Run Flyway using existing config
                sh './flyway-9.8.1/flyway -configFiles=flyway.conf migrate'
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