#!/usr/bin/env bash

#check that we can..
if [ -z $(docker version | awk '/kubernetes/ {print "True"}') ] ; then echo "You don't have kubernetes on docker!"; fi


# Let create all the Istio stuff we need ..

kubectl apply -f istio/istio-auth.yaml

# At this point thats it...done
# can now install applications etc..
# we can add more plugins..

# ###### lets add automatic sidecar injector webhook..
# Kubernetes CA approval permissions to create and approve CSR.
./istio/webhook-create-signed-cert.sh  --service istio-sidecar-injector --namespace istio-system --secret sidecar-injector-certs


# now to install the sidercar injection configmap
kubectl apply -f istio/istio-sidecar-injector-configmap-release.yaml

cat istio/istio-sidecar-injector.yaml | ./istio/webhook-patch-ca-bundle.sh > istio/istio-sidecar-injector-with-ca-bundle.yaml

# install the sidecar injector webhook
kubectl apply -f istio/istio-sidecar-injector-with-ca-bundle.yaml

# adding tracing with zipkin.
kubectl apply -f istio/addons/zipkin.yaml

# prometheus
kubectl apply -f istio/addons/prometheus.yaml

# to collect the telemetry you need yo add some stuff...not included here......yet..

# adding graphana..
kubectl apply -f istio/addons/grafana.yaml

# To view a graphical representation of your service mesh, install the Servicegraph add-on
kubectl apply -f istio/addons/servicegraph.yaml

# kubernetes..
kubectl apply -f kubernetes-dashboard/kubernetes-dashboard.yaml


