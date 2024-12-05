@Library('jenkins-shared-library@master') _
pipeline {
    agent {
        label 'terraform-build-agent'
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
        stage('Terraform Init') {
            steps {
              withCredentials([usernamePassword(credentialsId: 'AWS_CRED', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                container('terraform') {
                    script {
                        terraform.init('ec2', 'terraform-state-techiescamp', 'jenkins/terraform.tfstate', 'us-west-2')
                    }
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
                        terraform.plan('ec2')
                    }
                }
            }
        }
        stage('Terraform Apply/Destroy') {
            steps {
                container('terraform') {
                    script {
                        if (params.ACTION == 'apply') {
                            terraform.apply('ec2')
                        } else if (params.ACTION == 'destroy') {
                            terraform.destroy('ec2')
                        }
                    }
                }
            }
        }
    }
}
