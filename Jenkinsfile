pipeline {
    agent any
    
    environment {
        SNOWFLAKE_CREDS = credentials('snowflake-credentials1')
    }
    
    stages {
        stage('Run Migration') {
            steps {
                // Download Flyway
                sh 'wget https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/9.8.1/flyway-commandline-9.8.1.tar.gz'
                sh 'tar -xzf flyway-commandline-9.8.1.tar.gz'
                
                // Download Snowflake JDBC driver
                sh 'wget https://repo1.maven.org/maven2/net/snowflake/snowflake-jdbc/3.13.30/snowflake-jdbc-3.13.30.jar'
                sh 'mv snowflake-jdbc-3.13.30.jar flyway-9.8.1/drivers/'
                
                // Create flyway config
                writeFile file: 'flyway.conf', text: """
                    flyway.url=jdbc:snowflake://zvb91206.snowflakecomputing.com
                    flyway.user=${SNOWFLAKE_CREDS_USR}
                    flyway.password=${SNOWFLAKE_CREDS_PSW}
                    flyway.locations=filesystem:db
                    flyway.database=TEST
                    flyway.schema=DEMO
                    flyway.defaultSchema=DEMO
                    flyway.jdbcProperties.warehouse=COMPUTE_WH
                """
                
                // Run migration
                sh './flyway-9.8.1/flyway migrate'
            }
        }
    }
}