pipeline {
    agent any
    
    environment {
        SNOWFLAKE_ACCOUNT = 'ASCEAJN-RD78664'
        SNOWFLAKE_WAREHOUSE = 'COMPUTE_WH'
        SNOWFLAKE_ROLE = 'ACCOUNTADMIN'
        JAVA_TOOL_OPTIONS = '--add-opens=java.base/java.nio=org.apache.arrow.memory.core,ALL-UNNAMED'
        FLYWAY_VERSION = '10.21.0'
    }
    
    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'test', 'prod'],
            description: 'Select the environment to run migrations on'
        )
        choice(
            name: 'FLYWAY_TASK',
            choices: ['info', 'migrate', 'validate', 'repair'],
            description: 'Select the Flyway task to execute'
        )
    }
    
    stages {
        stage('Read Configuration') {
            steps {
                script {
                    def config = readProperties file: "configs/${params.ENVIRONMENT}.conf"
                    env.DATABASE_NAME = config.database
                }
            }
        }
        
        stage('Run Flyway Migration') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'snowflake-credentials1', 
                                usernameVariable: 'SNOWFLAKE_USER', 
                                passwordVariable: 'SNOWFLAKE_PASSWORD')]) {
                    sh """
                        ./flyway-${FLYWAY_VERSION}/flyway \
                        -url="jdbc:snowflake://\${SNOWFLAKE_ACCOUNT}.snowflakecomputing.com/?warehouse=\${SNOWFLAKE_WAREHOUSE}&db=\${DATABASE_NAME}&role=\${SNOWFLAKE_ROLE}"\
                        -user=\${SNOWFLAKE_USER} \
                        -password=\${SNOWFLAKE_PASSWORD} \
                        -locations=filesystem:./db \
                        -defaultSchema="flyway" \
                        -placeholders.DATABASE_NAME=\${DATABASE_NAME} \
                        \${FLYWAY_TASK}
                    """
                }
            }
        }
    }
}