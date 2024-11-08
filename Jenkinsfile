pipeline{
    agent any
    environment{
        registry= "bdelpozo/devops-dice"
        registryCredentials="dockerhub"
        project="devops-dice"
        projectVersion="1.1"
        repository="https://github.com/bdelpozo/devops-dice.git"
        repositoryCredentials="github"
    }
    stages{
        stage('Clean Workspace'){
            steps{
                cleanWs()
            }
        }
        stage('Checkout code'){
            steps{
                script{
                    git branch: 'main',
                        credentialsId: repositoryCredentials,
                        url: repository
                }
            }
        }

        stage('Code Analysis'){
            environment{
                scannerHome= tool 'Sonar'
            }
            steps{
                script{
                    withSonarQubeEnv('Sonar'){
                        sh "${scannerHome}/bin/sonar-scanner \
                        -Dsonar.projectKey=$project \
                        -Dsonar.projectName=$project \
                        -Dsonar.projectVersion=$projectVersion \
                        -Dsonar.sources=./"
                    }
                }
            }
        }

        stage('Build'){
            steps{
                script{
                    dockerImage= docker.build registry
                }
            }
        }

        stage('Test'){
            steps{
                script{
                    try{
                        sh 'docker run --name $project $registry'
                    }catch (Exception e){
                        currentBuild.result = 'FAILURE'
                         error("Pipeline failed")
                    }
                    finally{
                        sh 'docker rm $project'
                    }

                }
            }
        }

        stage('Deploy'){
            steps{
                script{
                    docker.withRegistry('',registryCredentials ){
                        dockerImage.push()
                    }
                }
            }
        }

    }
    post{
        failure{
            script{
                echo "Pipeline failed"
            }
        }
        success{
            script{
                echo 'Pipeline succeeded'
            }
        }
    }
}