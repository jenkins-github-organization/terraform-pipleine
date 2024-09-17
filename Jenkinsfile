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
                    volumeMounts:
                    - name: terraform-state
                      mountPath: /terraform-state
                  volumes:
                  - name: terraform-state
                    persistentVolumeClaim:
                      claimName: jenkins-pv-claim
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
            steps {
                container('terraform') {
                    sh 'tflint --chdir=ec2'
                }
            }
        }
        stage('Terraform Init') {
            steps {
                container('terraform') {
                    sh '''
                        terraform -chdir=ec2 init \
                        -backend-config="path=/terraform-state/terraform.tfstate"
                    '''
                }
            }
        }
        stage('Checkov') {
            steps {
                container('terraform') {
                    sh 'checkov --directory ec2'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                container('terraform') {
                    sh 'terraform -chdir=ec2 plan -out=/terraform-state/tfplan'
                }
            }
        }
        stage('Terraform Apply/Destroy') {
            steps {
                container('terraform') {
                    script {
                        if (params.ACTION == 'apply') {
                            sh 'terraform -chdir=ec2 apply -auto-approve /terraform-state/tfplan'
                        } else if (params.ACTION == 'destroy') {
                            sh 'terraform -chdir=ec2 destroy -auto-approve'
                        }
                    }
                }
            }
        }
        stage('Cleanup') {
            steps {
                container('terraform') {
                    sh '''
                        rm -f /terraform-state/tfplan
                        cp ec2/.terraform.lock.hcl /terraform-state/ || true
                    '''
                }
            }
        }
    }
}