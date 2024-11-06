pipeline {
    agent any
    
    environment {
        FLYWAY_VERSION = '9.22.3'
        SNOWFLAKE_ACCOUNT = credentials('ZVB91206')
        SNOWFLAKE_USER = credentials('akhilgurrapu')
        SNOWFLAKE_PASSWORD = credentials('Akhil@1997')
        SNOWFLAKE_WAREHOUSE = 'DEV_WH'
        SNOWFLAKE_DATABASE = 'DEV'
    }
    
    stages {
        stage('Setup') {
            steps {
                script {
                    // Wrap steps in a node block
                    node {
                        sh 'docker run --rm redgate/flyway'
                    }
                }
            }
        }
        
        stage('Run Flyway Migration') {
            steps {
                script {
                    // Wrap steps in a node block
                    node {
                        sh '''
                            flyway -url="jdbc:snowflake://${SNOWFLAKE_ACCOUNT}.snowflakecomputing.com" \
                            -user=${SNOWFLAKE_USER} \
                            -password=${SNOWFLAKE_PASSWORD} \
                            -warehouse=${SNOWFLAKE_WAREHOUSE} \
                            -database=${SNOWFLAKE_DATABASE} \
                            -locations=filesystem:./migrations \
                            migrate
                        '''
                    }
                }
            }
        }
    }
    
    post {
        always {
            script {
                // Wrap cleanup in a node block
                node {
                    cleanWs()
                }
            }
        }
    }
}