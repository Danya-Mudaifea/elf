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
    TOKEN=credentials('5ed23eb1-9ef7-453a-b702-50464e8c797f')
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
