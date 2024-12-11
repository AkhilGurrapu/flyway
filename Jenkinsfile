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
        [
            $class: 'ChoiceParameter',
            choiceType: 'PT_SINGLE_SELECT',
            description: 'Select Flyway or Scripts execution',
            name: 'EXECUTION_TYPE',
            script: [
                $class: 'GroovyScript',
                script: [
                    classpath: [],
                    sandbox: true,
                    script: 'return ["Flyway", "Scripts"]'
                ]
            ]
        ],
        [
            $class: 'CascadeChoiceParameter',
            choiceType: 'PT_SINGLE_SELECT',
            description: 'Select the environment',
            name: 'ENVIRONMENT',
            referencedParameters: 'EXECUTION_TYPE',
            script: [
                $class: 'GroovyScript',
                script: [
                    classpath: [],
                    sandbox: true,
                    script: '''
                        if (EXECUTION_TYPE == 'Flyway') {
                            return ['dev', 'test', 'prod']
                        } else {
                            return ['prod', 'non-prod']
                        }
                    '''
                ]
            ]
        ],
        [
            $class: 'CascadeChoiceParameter',
            choiceType: 'PT_SINGLE_SELECT',
            description: 'Select the operation type',
            name: 'OPERATION_TYPE',
            referencedParameters: 'EXECUTION_TYPE',
            script: [
                $class: 'GroovyScript',
                script: [
                    classpath: [],
                    sandbox: true,
                    script: '''
                        if (EXECUTION_TYPE == 'Flyway') {
                            return ['info', 'validate', 'migrate', 'repair']
                        }
                        return []
                    '''
                ]
            ]
        ]
    }
    
    stages {
        stage('Execute Selected Task') {
            steps {
                script {
                    if (params.EXECUTION_TYPE == 'Flyway') {
                        executeFlyway()
                    } else {
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
            def config = readProperties file: "configs/${params.ENVIRONMENT.toLowerCase()}.conf"
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
                \${params.OPERATION_TYPE}
            """
        }
    }
}

def executeScripts() {
    stage('Read Script Configuration') {
        script {
            def configFile = params.ENVIRONMENT == 'prod' ? 'configs/prod.conf' : 'configs/dev.conf'
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