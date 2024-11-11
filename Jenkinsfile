pipeline {
    agent any
    
    environment {
        FLYWAY_VERSION = '8.5.13'
        SNOWFLAKE_ACCOUNT = 'TVDWARH-WSB57083'
        SNOWFLAKE_USER = credentials('akhilgurrapu')
        SNOWFLAKE_PASSWORD = credentials('Akhil@1997')
        SNOWFLAKE_WAREHOUSE = 'COMPUTE_WH'
        SNOWFLAKE_DATABASE = 'TEST'
        SNOWFLAKE_SCHEMA = 'DEMO'
    }
    
    stages {
        stage('Run Flyway Migration') {
            steps {
                script {
                    // Download Flyway CLI
                    sh "wget -q https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz"
                    sh "tar -xzf flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz"
                    
                    // Run Flyway migration
                    sh """
                    ./flyway-${FLYWAY_VERSION}/flyway \
                    -url=jdbc:snowflake://${SNOWFLAKE_ACCOUNT}.snowflakecomputing.com \
                    -user=${SNOWFLAKE_USER} \
                    -password=${SNOWFLAKE_PASSWORD} \
                    -warehouse=${SNOWFLAKE_WAREHOUSE} \
                    -database=${SNOWFLAKE_DATABASE} \
                    -schema=${SNOWFLAKE_SCHEMA} \
                    migrate
                    """
                }
            }
        }
    }
}