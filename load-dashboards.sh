#!/usr/bin/env bash


#add the zipkin dashboard
# Access the dashboard with the following:
kubectl port-forward -n istio-system $(kubectl get pod -n istio-system -l app=zipkin -o jsonpath='{.items[0].metadata.name}') 9411:9411 &
open  http://localhost:9411


# view the Graphana dashboard here..
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3000:3000 &
open http://localhost:3000/dashboard/db/istio-dashboard

# To view a graphical representation of your service mesh, using the Servicegraph add-on
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=servicegraph -o jsonpath='{.items[0].metadata.name}') 8088:8088 &
open http://localhost:8088/dotviz


# Load the Kubernetes dashboard in the browser by automatically detecting the correct pod and starting the port forwarding

kubectl -n kube-system port-forward $(kubectl -n kube-system get pod -l k8s-app=kubernetes-dashboard -o jsonpath='{.items[0].metadata.name}') 9090:9090 &
open http://localhost:9090
