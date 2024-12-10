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
            name: 'EXECUTION_TYPE',
            choices: ['flyway', 'scripts'],
            description: 'Select whether to run Flyway migrations or SQL scripts'
        )
    }
    
    stages {
        stage('Determine Execution Path') {
            steps {
                script {
                    if (params.EXECUTION_TYPE == 'flyway') {
                        // Call the Flyway pipeline
                        flyway_pipeline()
                    } else {
                        // Call the Scripts pipeline
                        scripts_pipeline()
                    }
                }
            }
        }
    }
}

// Define the original Flyway pipeline as a function
def flyway_pipeline() {
    pipeline {
        agent any
        
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
            stage('Read Flyway Configuration') {
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
}

// Define the Scripts pipeline as a function
def scripts_pipeline() {
    pipeline {
        agent any
        
        parameters {
            choice(
                name: 'SCRIPT_ENV',
                choices: ['prod', 'non-prod'],
                description: 'Select the environment for script execution'
            )
        }
        
        stages {
            stage('Read Script Configuration') {
                steps {
                    script {
                        def configFile = params.SCRIPT_ENV == 'prod' ? 'configs/prod.conf' : 'configs/dev.conf'
                        def config = readProperties file: configFile
                        env.DATABASE_NAME = config.database
                    }
                }
            }
            
            stage('Execute SQL Scripts') {
                steps {
                    withCredentials([usernamePassword(credentialsId: 'snowflake-credentials1', 
                                    usernameVariable: 'SNOWFLAKE_USER', 
                                    passwordVariable: 'SNOWFLAKE_PASSWORD')]) {
                        script {
                                // Execute all scripts in the scripts folder
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
            }
        }
    }
}