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
    TOKEN=credentials('3b922df4-310b-40b0-8102-311721c247ea')
  }

stages { 
  stage('delete') {
          steps {
              container('kubectl') {
                  sh '''
                     helm uninstall elasticsearch --namespace=elf
	             helm uninstall fluent-bit --namespace=elf
	             helm uninstall kibana --namespace=elf
                     kubectl delete random-logger -n elf
                  '''
              }
          }
      }
  
  
  
    stage('deploy:kubectl') {
          steps {
              container('kubectl') {
                  sh '''
                       kubectl --token=$TOKEN create namespace elf
		       kubectl create -n labs clusterrolebinding jenkins --clusterrole cluster-admin --serviceaccount=jenkins:default 
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
                     helm install elasticsearch elastic/elasticsearch --version=7.9.0 --namespace=elf
                     helm install fluent-bit fluent/fluent-bit --namespace=elf
                     helm install kibana elastic/kibana --version=7.9.0 --namespace=elf --set service.type=NodePort
                   '''
                          
          }
      }
   }
 }
}
