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

    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Select whether to apply or destroy infrastructure.')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Tflint') {
            when {
                expression { params.ACTION == 'apply' }
            }
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
            when {
                expression { params.ACTION == 'apply' }
            }
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
            when {
                expression { params.ACTION == 'apply' }
            }
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
        stage('Terraform Apply/Destroy') {
            steps {
                container('terraform') {
                    script {
                        if (params.ACTION == 'apply') {
                            sh '''
                                terraform -chdir=ec2 apply -auto-approve
                            '''
                        } else if (params.ACTION == 'destroy') {
                            sh '''
                                terraform -chdir=ec2 destroy -auto-approve
                            '''
                        }
                    }
                }
            }
        }
    }
}
