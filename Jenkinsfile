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
                        tfLint.test('ec2')
                    }
                }
            }
        }
        stage('Terraform Init') {
            steps {
                container('terraform') {
                    script {
                        terraform.init('ec2', 'terraform-state-techiescamp', 'jenkins/terraform.tfstate', 'us-west-2')
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
                        checkov.scan('ec2')
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
