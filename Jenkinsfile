@Library('jenkins-shared-library@main') _
pipeline {
    agent {
        kubernetes {
            yaml '''
                apiVersion: v1
                kind: Pod
                spec:
                  containers:
                  - name: terraform
                    image: techiescamp/terraform-agent:2.0.0
                    command:
                    - cat
                    tty: true
            '''
        }
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Tflint') {
            steps {
                container('terraform') {
                    script {
                        sh '''
                            tflint --chdir=ec2
                            '''
                    }
                }
            }
        }
        stage('Terraform Init') {
            steps {
                container('terraform') {
                    script {
                        sh '''
                            terraform -chdir=ec2 init
                            '''
                    }
                }
            }
        }
        stage('Checkov') {
            steps {
                container('terraform') {
                    script {
                        sh '''
                            checkov --directory ec2
                            '''
                    }
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                container('terraform') {
                    script {
                        sh '''
                            terraform -chdir=ec2 plan
                            '''
                    }
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                container('terraform') {
                    script {
                        sh '''
                            terraform -chdir=/workspace/ec2 apply -auto-approve
                            '''
                    }
                }
            }
        }
    }
}
