pipeline {
    agent any
    tools {
        maven 'maven-3.9.9'
    }
    environment{
        registry = '034362040994.dkr.ecr.us-east-1.amazonaws.com/myappdevsecops'
        registryCredential = 'jenkins-ecr-login-1'
    }
    stages {
        stage("Checkout the projet") {
            steps {
                git branch: 'main', url: 'https://github.com/Tsafac/techstart-jenkins-deploy-to-k8-repo.git'

            }
        }
        stage("Build the package") {
            steps {
                sh 'mvn clean package'
            }
        }
        stage("Sonar Quality check") {
            steps {
                script{
                withSonarQubeEnv(installationName: 'sonar-9', credentialsId: 'token') {
                sh 'mvn sonar:sonar'
                }
              }
            }
        }
        stage('RunSCAAnalysisUsingSnyk') {
            steps {
                withCredentials([string(credentialsId: 'snyk_token', variable: 'SNYK_TOKEN')]) {
                    sh 'mvn snyk:test -fn || true'
                }
            }
        }
        stage('Building our image') {
            steps{
                script {
                dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
             }
         }
         stage('Deploy our image to AWS ECR') {
             steps{
                 script {
                 docker.withRegistry("http://" + registry, "ecr:us-east-1:" + registryCredential ) {
                 dockerImage.push()
                 }
            }
        }
      }
         stage ("Sending deployment & service.yaml file to EKS Client Machine"){
             steps{
                 sshagent(['clientekslogin']) {
                     sh 'ssh -o StrictHostKeyChecking=no ec2-user@IP_CLIENT_EKS'
                     sh 'scp "/var/lib/jenkins/workspace/jenkins-maven-pipeline-1/deployment.yaml" ec2-user@IP_CLIENT_EKS:/tmp'
                     sh 'scp "/var/lib/jenkins/workspace/jenkins-maven-pipeline-1/service.yaml" ec2-user@IP_CLIENT_EKS:/tmp'
                 }
             }
         }
         stage("Executing Application"){
             steps{
                 sshagent(['clientekslogin']) {
                     sh 'ssh -o StrictHostKeyChecking=no ec2-user@IP_CLIENT_EKS cd /tmp'
                     sh 'ssh -o StrictHostKeyChecking=no ec2-user@IP_CLIENT_EKS /home/ec2-user/bin/kubectl delete all --all -n securityapp'
                     sh 'ssh -o StrictHostKeyChecking=no ec2-user@IP_CLIENT_EKS kubectl apply -f /tmp/deployment.yaml -n securityapp'
                     sh 'ssh -o StrictHostKeyChecking=no ec2-user@IP_CLIENT_EKS kubectl apply -f /tmp/service.yaml -n securityapp'
                 }
             }
         }
         stage("copy the Zap Script to EKS Client"){
             steps{
                 sshagent(['clientekslogin']) {
                     sh 'ssh -o StrictHostKeyChecking=no ec2-user@IP_CLIENT_EKS'
                     sh 'scp "/var/lib/jenkins/workspace/jenkins-maven-pipeline-1/scrp.sh" ec2-user@IP_CLIENT_EKS:/tmp'
                 }
             }
         }
         stage ("wait while the the Techstart application should be up & running"){
             steps{
                 sh 'date; pwd; sleep 90; echo "application is being started on k8s Cluster"'
             }
         }
         stage("Dynamic Appln Security Testing Using Zap Tool"){
             steps{
                 sshagent(['clientekslogin']) {
                     sh 'ssh -o StrictHostKeyChecking=no ec2-user@IP_CLIENT_EKS'
                     sh 'ssh -o StrictHostKeyChecking=no ec2-user@IP_CLIENT_EKS sh /tmp/scrp.sh'
                 } 
             }
         }
    }
}
