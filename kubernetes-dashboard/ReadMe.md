Get the name of the kubernetes pod to port forward to.

kubectl get pod --namespace=kube-system | grep dashboard

and the do the port forwarding

kubectl port-forward <pod name> 9090:9090 --namespace=kube-system

location in browser to view the dashboard is  http://127.0.0.1:9090
