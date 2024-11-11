pipeline {
    agent any

    environment {
        FLYWAY_VERSION = '9.20.0'
        SNOWFLAKE_ACCOUNT = 'TVDWARH-WSB57083'
        SNOWFLAKE_WAREHOUSE = 'COMPUTE_WH'
        SNOWFLAKE_DATABASE = 'FLYWAY'
        SNOWFLAKE_SCHEMA = 'flyway_schema_history'
    }

    stages {
        stage('Setup Flyway') {
            steps {
                sh """
                    wget -q -O flyway.tar.gz https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz
                    tar -xzf flyway.tar.gz
                    rm flyway.tar.gz
                """
            }
        }

        stage('Run Flyway Migration') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'snowflake-credentials1', usernameVariable: 'SNOWFLAKE_USER', passwordVariable: 'SNOWFLAKE_PASSWORD')]) {
                    sh """
                        ./flyway-${FLYWAY_VERSION}/flyway \
                        -url="jdbc:snowflake://${SNOWFLAKE_ACCOUNT}.snowflakecomputing.com" \
                        -user=${SNOWFLAKE_USER} \
                        -password=${SNOWFLAKE_PASSWORD} \
                        -locations=filesystem:${WORKSPACE}/db \
                        -connectRetries=10 \
                        -jdbcProperties.JDBC_QUERY_RESULT_FORMAT=JSON \
                        migrate
                    """
                }
            }
        }
    }
}