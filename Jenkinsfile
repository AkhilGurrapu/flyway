pipeline {
    agent any
    
    environment {
        FLYWAY_VERSION = '9.22.3'
        SNOWFLAKE_ACCOUNT = credentials('TVDWARH-WSB57083')
        SNOWFLAKE_USER = credentials('akhilgurrapu')
        SNOWFLAKE_PASSWORD = credentials('Akhil@1997')
        SNOWFLAKE_WAREHOUSE = 'DEV_WH'
        SNOWFLAKE_DATABASE = 'DEV'
    }
    
    stages {
        stage('Setup') {
            steps {
                sh '''
                    wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz | tar xvz
                    sudo ln -s `pwd`/flyway-${FLYWAY_VERSION}/flyway /usr/local/bin
                '''
            }
        }
        
        stage('Run Flyway Migration') {
            steps {
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
    
    post {
        always {
            cleanWs()
        }
    }
}