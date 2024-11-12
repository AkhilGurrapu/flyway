pipeline {
    agent any
    
    environment {
        FLYWAY_VERSION = '10.21.0'
        SNOWFLAKE_ACCOUNT = 'TVDWARH-WSB57083'
        SNOWFLAKE_WAREHOUSE = 'COMPUTE_WH'
        JAVA_TOOL_OPTIONS = '--add-opens=java.base/java.nio=org.apache.arrow.memory.core,ALL-UNNAMED'
    }
    
    parameters {
        choice(
            name: 'DATABASE_NAME',
            choices: ['FLYWAY', 'test', 'flywaychecking'],
            description: 'Select the database to run migrations on'
        )
        // choice(
        //     name: 'SCHEMA_NAME',
        //     choices: ['PUBLIC', 'DEV', 'PROD', 'DEMO'],
        //     description: 'Select the schema to use'
        // )
    }
    
    stages {
        stage('Run Flyway Migration') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'snowflake-credentials1', 
                                usernameVariable: 'SNOWFLAKE_USER', 
                                passwordVariable: 'SNOWFLAKE_PASSWORD')]) {
                    sh """
                        ./flyway-\${FLYWAY_VERSION}/flyway \
                        -url="jdbc:snowflake://\${SNOWFLAKE_ACCOUNT}.snowflakecomputing.com/?warehouse=\${SNOWFLAKE_WAREHOUSE}" \
                        -user=\${SNOWFLAKE_USER} \
                        -password=\${SNOWFLAKE_PASSWORD} \
                        -locations=filesystem:./db \
                        -defaultSchema="flyway" \
                        migrate
                    """
                }
            }
        }
    }
}