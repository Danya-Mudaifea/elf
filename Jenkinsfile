pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
metadata:
spec:
  containers:
  - name: helm
    image: alpine/helm
    command: 
    - cat
    tty: true
  - name: kubectl
    image: bryandollery/terraform-packer-aws-alpine
    command:
    - cat
    tty: true
"""
    }
  }   

environment {
    TOKEN=credentials('6fff3a41-3383-41f4-9e32-5945ad8f348b')
  }

stages { 
    stage('deploy:kubectl') {
          steps {
              container('kubectl') {
                  sh '''
                       kubectl --token=$TOKEN create namespace elfdelta1
                  '''
              }
          }
      }


    stage('deploy:helm') {
            steps {
                container('helm') {
                   sh '''
                     helm repo add elastic https://helm.elastic.co
                     helm repo add fluent https://fluent.github.io/helm-charts
                     helm repo update
                     helm install elasticsearch elastic/elasticsearch --version=7.9.0 --namespace=elfdelta1
                     helm install fluent-bit fluent/fluent-bit --namespace=elfdelta1
                     helm install kibana elastic/kibana --version=7.9.0 --namespace=elfdelta1 --set service.type=NodePort
                   '''
                          
          }
      }
   }
 }
}
