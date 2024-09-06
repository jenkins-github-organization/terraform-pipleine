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
                    image: techiescamp/terraform-agent:1.0.0
                    command:
                    - cat
                    tty: true
            '''
        }
    }

    stages {
        stage('Git Checkout') {
            steps {
                gitCheckout(
                    branch: "main",
                    url: "https://github.com/kubernetes-learning-projects/kube-petclinc-app.git"
                )
            }
        }
    }
}
