pipeline {
    agent any
    
    environment {
        SNOWFLAKE_ACCOUNT = 'ASCEAJN-RD78664'
        SNOWFLAKE_WAREHOUSE = 'COMPUTE_WH'
        SNOWFLAKE_ROLE = 'ACCOUNTADMIN'
        JAVA_TOOL_OPTIONS = '--add-opens=java.base/java.nio=org.apache.arrow.memory.core,ALL-UNNAMED'
        FLYWAY_VERSION = '10.21.0'
    }  
    
    stages {
        stage('Execute') {
            steps {
                script {
                    echo "Execution Type: ${params.EXECUTION_TYPE}"
                    echo "Environment: ${params.ENVIRONMENT}"
                    echo "Operation Type: ${params.OPERATION_TYPE}"
                    
                    if (params.EXECUTION_TYPE?.trim() && params.EXECUTION_TYPE == 'Flyway') {
                        executeFlyway()
                    } else if (params.EXECUTION_TYPE?.trim() && params.EXECUTION_TYPE == 'Scripts') {
                        executeScripts()
                    } else {
                        error "Invalid or missing EXECUTION_TYPE parameter"
                    }
                }
            }
        }
    }
}

def executeFlyway() {
    stage('Read Flyway Configuration') {
        script {
            if (!params.ENVIRONMENT?.trim()) {
                error "Environment parameter is required for Flyway execution"
            }
            if (!params.OPERATION_TYPE?.trim()) {
                error "Operation Type parameter is required for Flyway execution"
            }
            
            def config = readProperties file: "configs/${params.ENVIRONMENT.toLowerCase()}.conf"
            env.DATABASE_NAME = config.database
            
            echo "Database Name: ${env.DATABASE_NAME}"
        }
    }
    
    stage('Run Flyway Migration') {
        withCredentials([usernamePassword(credentialsId: 'snowflake-credentials1', 
                        usernameVariable: 'SNOWFLAKE_USER', 
                        passwordVariable: 'SNOWFLAKE_PASSWORD')]) {
            sh """
                ./flyway-${FLYWAY_VERSION}/flyway \
                -url="jdbc:snowflake://\${SNOWFLAKE_ACCOUNT}.snowflakecomputing.com/?warehouse=\${SNOWFLAKE_WAREHOUSE}&db=\${DATABASE_NAME}&role=\${SNOWFLAKE_ROLE}" \
                -user=\${SNOWFLAKE_USER} \
                -password=\${SNOWFLAKE_PASSWORD} \
                -locations=filesystem:./db \
                -defaultSchema="flyway" \
                -placeholders.DATABASE_NAME=\${DATABASE_NAME} \
                ${params.OPERATION_TYPE ?: 'info'}
            """
        }
    }
}

def executeScripts() {
    stage('Read Script Configuration') {
        script {
            if (!params.ENVIRONMENT?.trim()) {
                error "Environment parameter is required for Scripts execution"
            }
            
            def configFile = params.ENVIRONMENT == 'prod' ? 'configs/prod.conf' : 'configs/dev.conf'
            def config = readProperties file: configFile
            env.DATABASE_NAME = config.database
            
            echo "Database Name: ${env.DATABASE_NAME}"
        }
    }
    
    stage('Execute SQL Scripts') {
        withCredentials([usernamePassword(credentialsId: 'snowflake-credentials1', 
                        usernameVariable: 'SNOWFLAKE_USER', 
                        passwordVariable: 'SNOWFLAKE_PASSWORD')]) {
            sh """
                for script in scripts/*.sql; do
                    echo "Executing \$script..."
                    snowsql -a \${SNOWFLAKE_ACCOUNT} \
                    -u \${SNOWFLAKE_USER} \
                    -p \${SNOWFLAKE_PASSWORD} \
                    -w \${SNOWFLAKE_WAREHOUSE} \
                    -d \${DATABASE_NAME} \
                    -r \${SNOWFLAKE_ROLE} \
                    -f \$script
                done
            """
        }
    }
}