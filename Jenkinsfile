pipeline {
    agent any

    stages {
        stage('Build Flyway') {
            steps {
                sh '''
                    $ wget -qO- https://download.red-gate.com/maven/release/com/redgate/flyway/flyway-commandline/10.21.0/flyway-commandline-10.21.0-linux-x64.tar.gz | tar -xvz && sudo ln -s `pwd`/flyway-10.21.0/flyway /usr/local/bin 
                '''
            }
        }

}