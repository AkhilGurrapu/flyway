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
            name: 'ENVIRONMENT',
            choices: ['dev', 'test', 'prod'],
            description: 'Select the environment to run migrations on'
        )
        choice(
            name: 'FLYWAY_TASK',
            choices: ['info', 'migrate'],
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
                        ./flyway-\${FLYWAY_VERSION}/flyway \
                        -url="jdbc:snowflake://\${SNOWFLAKE_ACCOUNT}.snowflakecomputing.com/?warehouse=\${SNOWFLAKE_WAREHOUSE}&db=\${DATABASE_NAME}"\
                        -user=\${SNOWFLAKE_USER} \
                        -password=\${SNOWFLAKE_PASSWORD} \
                        -locations=filesystem:./db \
                        -defaultSchema="flyway" \
                        \${FLYWAY_TASK}
                    """
                }
            }
        }
    }
}