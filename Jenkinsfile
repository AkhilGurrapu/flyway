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
            choices: ['Select Type', 'flyway', 'scripts'],
            description: 'Select whether to run Flyway migrations or SQL scripts'
        )
        activeChoice(
            name: 'ENVIRONMENT',
            script: [
                $class: 'GroovyScript',
                script: [
                    classpath: [], 
                    sandbox: true, 
                    script: '''
                        if (EXECUTION_TYPE.equals('flyway')) {
                            return ['dev', 'test', 'prod']
                        }
                        return []
                    '''
                ]
            ],
            description: 'Select the environment for Flyway migrations',
            filterLength: 1,
            filterable: false,
            referencedParameters: 'EXECUTION_TYPE'
        )
        activeChoice(
            name: 'FLYWAY_TASK',
            script: [
                $class: 'GroovyScript',
                script: [
                    classpath: [], 
                    sandbox: true, 
                    script: '''
                        if (EXECUTION_TYPE.equals('flyway')) {
                            return ['info', 'migrate', 'validate', 'repair']
                        }
                        return []
                    '''
                ]
            ],
            description: 'Select the Flyway task to execute',
            filterLength: 1,
            filterable: false,
            referencedParameters: 'EXECUTION_TYPE'
        )
        activeChoice(
            name: 'SCRIPT_ENV',
            script: [
                $class: 'GroovyScript',
                script: [
                    classpath: [], 
                    sandbox: true, 
                    script: '''
                        if (EXECUTION_TYPE.equals('scripts')) {
                            return ['prod', 'non-prod']
                        }
                        return []
                    '''
                ]
            ],
            description: 'Select the environment for script execution',
            filterLength: 1,
            filterable: false,
            referencedParameters: 'EXECUTION_TYPE'
        )
    }
    
    stages {
        stage('Parameter Validation') {
            steps {
                script {
                    if (params.EXECUTION_TYPE == 'Select Type') {
                        error "Please select a valid execution type (flyway or scripts)"
                    }
                    
                    // Validate Flyway parameters
                    if (params.EXECUTION_TYPE == 'flyway') {
                        if (!params.ENVIRONMENT || !params.FLYWAY_TASK) {
                            error "Please provide all required Flyway parameters"
                        }
                    }
                    
                    // Validate Scripts parameters
                    if (params.EXECUTION_TYPE == 'scripts') {
                        if (!params.SCRIPT_ENV) {
                            error "Please provide all required Scripts parameters"
                        }
                    }
                }
            }
        }

        stage('Execute Selected Task') {
            steps {
                script {
                    if (params.EXECUTION_TYPE == 'flyway') {
                        executeFlyway()
                    } else if (params.EXECUTION_TYPE == 'scripts') {
                        executeScripts()
                    }
                }
            }
        }
    }
}

def executeFlyway() {
    stage('Read Flyway Configuration') {
        script {
            def config = readProperties file: "configs/${params.ENVIRONMENT}.conf"
            env.DATABASE_NAME = config.database
        }
    }
    
    stage('Run Flyway Migration') {
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

def executeScripts() {
    stage('Read Script Configuration') {
        script {
            def configFile = params.SCRIPT_ENV == 'prod' ? 'configs/prod.conf' : 'configs/dev.conf'
            def config = readProperties file: configFile
            env.DATABASE_NAME = config.database
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