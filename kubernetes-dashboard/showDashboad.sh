#!/usr/bin/env bash
# Load the Kubernetes dashboard in the browser by automatically detecting the correct pod and starting the port forwarding

kubectl get pod --namespace=kube-system | grep dashboard | awk '{print "kubectl port-forward "$1" 9090:9090 --namespace=kube-system &"}' | bash -

open http://localhost:9090

