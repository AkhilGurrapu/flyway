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
        choice(
            name: 'SCHEMA_NAME',
            choices: ['PUBLIC', 'DEV', 'PROD'],
            description: 'Select the schema to use'
        )
    }
    
    stages {
        // stage('Setup Flyway') {
        //     steps {
        //         sh """
        //             wget -q -O flyway.tar.gz https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/\${FLYWAY_VERSION}/flyway-commandline-\${FLYWAY_VERSION}-linux-x64.tar.gz
        //             tar -xzf flyway.tar.gz
        //             rm flyway.tar.gz
        //         """
        //     }
        // }
        
        stage('Run Flyway Migration') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'snowflake-credentials1', 
                                usernameVariable: 'SNOWFLAKE_USER', 
                                passwordVariable: 'SNOWFLAKE_PASSWORD')]) {
                    sh """
                        ./flyway-\${FLYWAY_VERSION}/flyway \
                        -url="jdbc:snowflake://\${SNOWFLAKE_ACCOUNT}.snowflakecomputing.com/?warehouse=\${SNOWFLAKE_WAREHOUSE}&db=${params.DATABASE_NAME}" \
                        -user=\${SNOWFLAKE_USER} \
                        -password=\${SNOWFLAKE_PASSWORD} \
                        -schemas=${params.SCHEMA_NAME} \
                        -locations=filesystem:./db \
                        migrate
                    """
                }
            }
        }
    }
}