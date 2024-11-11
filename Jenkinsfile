pipeline {
    agent any

    environment {
        FLYWAY_HOME = '/var/lib/jenkins/workspace/flyway-snowflake/flyway-9.20.0'
        SNOWFLAKE_ACCOUNT = 'TVDWARH-WSB57083'
    }

    stages {
        stage('Setup Flyway') {
            steps {
                sh '''
                    wget -q -O flyway.tar.gz https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/9.20.0/flyway-commandline-9.20.0-linux-x64.tar.gz
                    tar -xzf flyway.tar.gz
                    rm flyway.tar.gz
                '''
            }
        }

        stage('Run Flyway Migration') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'snowflake-credentials1', usernameVariable: 'SNOWFLAKE_USER', passwordVariable: 'SNOWFLAKE_PASSWORD')]) {
                    sh '''
                        ${FLYWAY_HOME}/flyway \
                        -url="jdbc:snowflake://${SNOWFLAKE_ACCOUNT}.snowflakecomputing.com" \
                        -user=${SNOWFLAKE_USER} \
                        -password=${SNOWFLAKE_PASSWORD} \
                        -locations=filesystem:${WORKSPACE}/db \
                        migrate
                    '''
                }
            }
        }
    }
}