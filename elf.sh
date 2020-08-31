#!/bin/bash
#
kubectl apply -f elf.namespace.yaml
helm repo add elastic https://helm.elastic.co
helm repo add fluent https://fluent.github.io/helm-charts
helm repo update
helm install elasticsearch elastic/elasticsearch --version=7.9.0 --namespace=elf --values toleration.yaml
helm install fluent-bit fluent/fluent-bit --namespace=elf --values toleration.yaml
helm install kibana elastic/kibana --version=7.9.0 --namespace=elf --set service.type=LoadBalancer --values toleration.yaml
kubectl run random-logger --image=chentex/random-logger -n elf --values toleration.yaml
kubectl apply -f ingress.yaml -n elf
