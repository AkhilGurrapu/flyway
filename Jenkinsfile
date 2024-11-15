pipeline {
    agent any
    
    environment {
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
        stage('Get Flyway Version') {
            steps {
                script {
                    // Find the Flyway directory dynamically
                    def flywayDir = sh(
                        script: 'ls -d flyway-* | head -n 1',
                        returnStdout: true
                    ).trim()
                    
                    // Store the Flyway path
                    env.FLYWAY_PATH = "./${flywayDir}/flyway"
                    
                    // Get and store the version
                    env.FLYWAY_VERSION = sh(
                        script: "${env.FLYWAY_PATH} --version | grep -oP 'Flyway\\s+\\K[0-9.]+'",
                        returnStdout: true
                    ).trim()
                    
                    echo "Using Flyway version: ${env.FLYWAY_VERSION}"
                    echo "Flyway path: ${env.FLYWAY_PATH}"
                }
            }
        }
        
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
                        ${env.FLYWAY_PATH} \
                        -url="jdbc:snowflake://\${SNOWFLAKE_ACCOUNT}.snowflakecomputing.com/?warehouse=\${SNOWFLAKE_WAREHOUSE}&db=\${DATABASE_NAME}"\
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