pipeline {
    agent any
    
    environment {
        // Snowflake credentials stored in Jenkins
        SNOWFLAKE_CREDS = credentials('snowflake-credentials1')
        FLYWAY_VERSION = '9.8.1'
        
        // Snowflake connection details
        SNOWFLAKE_ACCOUNT = 'zvb91206'
        SNOWFLAKE_WAREHOUSE = 'COMPUTE_WH'
        SNOWFLAKE_DATABASE = 'TEST'
        SNOWFLAKE_ROLE = 'ADMIN'
        SNOWFLAKE_SCHEMA = 'DEMO'

        
        // GitHub details
        GITHUB_REPO = 'https://github.com/AkhilGurrapu/flyway.git'
        GITHUB_BRANCH = 'main'
    }
    
    options {
        // Keep builds for 10 days
        buildDiscarder(logRotator(daysToKeepStr: '10'))
        // Timeout after 30 minutes
        timeout(time: 30, unit: 'MINUTES')
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Clean workspace before checkout
                cleanWs()
                git branch: env.GITHUB_BRANCH, url: env.GITHUB_REPO
            }
        }
        
        stage('Setup Flyway') {
            steps {
                script {
                    // Download and setup Flyway with Snowflake JDBC driver
                    sh """
                        wget https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}.tar.gz
                        tar -xzf flyway-commandline-${FLYWAY_VERSION}.tar.gz
                        
                        # Download Snowflake JDBC driver
                        wget https://repo1.maven.org/maven2/net/snowflake/snowflake-jdbc/3.13.30/snowflake-jdbc-3.13.30.jar
                        mv snowflake-jdbc-3.13.30.jar flyway-${FLYWAY_VERSION}/drivers/
                    """
                }
            }
        }
        
        stage('Validate Migrations') {
            steps {
                script {
                    // Validate all migration scripts
                    sh """
                        ./flyway-${FLYWAY_VERSION}/flyway \
                        -url="jdbc:snowflake://${SNOWFLAKE_ACCOUNT}.snowflakecomputing.com" \
                        -user="${SNOWFLAKE_CREDS_USR}" \
                        -password="${SNOWFLAKE_CREDS_PSW}" \
                        -snowflakeWarehouse="${SNOWFLAKE_WAREHOUSE}" \
                        -snowflakeDatabase="${SNOWFLAKE_DATABASE}" \
                        -snowflakeRole="${SNOWFLAKE_ROLE}" \
                        validate
                    """
                }
            }
        }
        
        stage('Show Migration Info') {
            steps {
                script {
                    // Show pending migrations
                    sh """
                        ./flyway-${FLYWAY_VERSION}/flyway \
                        -url="jdbc:snowflake://${SNOWFLAKE_ACCOUNT}.snowflakecomputing.com" \
                        -user="${SNOWFLAKE_CREDS_USR}" \
                        -password="${SNOWFLAKE_CREDS_PSW}" \
                        -snowflakeWarehouse="${SNOWFLAKE_WAREHOUSE}" \
                        -snowflakeDatabase="${SNOWFLAKE_DATABASE}" \
                        -snowflakeRole="${SNOWFLAKE_ROLE}" \
                        info
                    """
                }
            }
        }
        
        stage('Run Migrations') {
            steps {
                script {
                    // Execute migrations
                    sh """
                        ./flyway-${FLYWAY_VERSION}/flyway \
                        -url="jdbc:snowflake://${SNOWFLAKE_ACCOUNT}.snowflakecomputing.com" \
                        -user="${SNOWFLAKE_CREDS_USR}" \
                        -password="${SNOWFLAKE_CREDS_PSW}" \
                        -snowflakeWarehouse="${SNOWFLAKE_WAREHOUSE}" \
                        -snowflakeDatabase="${SNOWFLAKE_DATABASE}" \
                        -snowflakeRole="${SNOWFLAKE_ROLE}" \
                        migrate
                    """
                }
            }
        }
    }
    
    post {
        success {
            // Send success notification
            slackSend(
                color: 'good',
                message: "Snowflake migrations completed successfully! \nBuild: ${env.BUILD_URL}"
            )
        }
        failure {
            // Send failure notification
            slackSend(
                color: 'danger',
                message: "Snowflake migrations failed! \nBuild: ${env.BUILD_URL}"
            )
        }
        always {
            // Clean workspace
            cleanWs()
        }
    }
}