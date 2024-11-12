pipeline {
    agent any

    environment {
        FLYWAY_VERSION = '10.21.0'
        SNOWFLAKE_ACCOUNT = 'TVDWARH-WSB57083'
        SNOWFLAKE_WAREHOUSE = 'COMPUTE_WH'
        SNOWFLAKE_DATABASE = 'FLYWAY'
    }
    stages{
        stage('Deploy to Snowflake') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'snowflake-credentials1', usernameVariable: 'SNOWFLAKE_USER', passwordVariable: 'SNOWFLAKE_PASSWORD')]) {
                sh """
                    ./flyway-${FLYWAY_VERSION}/flyway \
                    -url="jdbc:snowflake://${SNOWFLAKE_ACCOUNT}.snowflakecomputing.com/?warehouse=${SNOWFLAKE_WAREHOUSE}&db=${SNOWFLAKE_DATABASE}" \
                    -user=${SNOWFLAKE_USER} -password=${SNOWFLAKE_PASSWORD} \
                    -locations=filesystem:./db migrate
                """
                }
            }
        }
    }
    
}


