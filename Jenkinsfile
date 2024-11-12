pipeline {
    agent any

    environment {
        FLYWAY_VERSION = '10.21.0'
        SNOWFLAKE_ACCOUNT = 'TVDWARH-WSB57083'
        SNOWFLAKE_WAREHOUSE = 'COMPUTE_WH'
        SNOWFLAKE_DATABASE = 'FLYWAY'
        SNOWFLAKE_USER = 'akhilgurrapu'
        SNOWFLAKE_PASSWORD = credentials('snowflake-password')
    }

    stages {

        stage('Run Flyway Migration') {
            steps {
                    sh """
                        ./flyway-${FLYWAY_VERSION}/flyway \
                        migrate -url=jdbc:snowflake://TVDWARH-WSB57083.snowflakecomputing.com/?warehouse=COMPUTE_WH&role=ACCOUNTADMIN&authenticator=snowflake&db=flyway -user=${SNOWFLAKE_USER} -password=${SNOWFLAKE_PASSWORD} -locations="filesystem:./db"

                    """
                }
            }
        }
    }