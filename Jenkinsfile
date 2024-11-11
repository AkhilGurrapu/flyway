pipeline {
    agent any
    
    stage('Run Migration') {
    steps {
        sh '''
            ls -la ${WORKSPACE}/flywayPipelines/flyway-9.22.3
            which flyway || echo "flyway not found in PATH"
            echo $PATH
        '''
        sh 'flyway -configFiles=flyway.conf migrate'
    }
}
    
    post {
        failure {
            echo 'Migration failed!'
        }
    }
}