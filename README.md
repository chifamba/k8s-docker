# k8s-docker

##Based on the Istio documentation


Istio, monitoring and ingress on docker-mac with Kubernetes

for the simple path execute the script init.sh in this repo.

 This note will document the steps and scripts needed to install istio on kubernetes
 including installing the kubernetes dashboard on docker-kubernetes.

 make sure you have enabled kubernetes with docker, currently in the edge stream.
 download the bits

```
mkdir -p $HOME/data/projects
cd $HOME/data/projects

curl -L https://git.io/getLatestIstio | sh -

cd istio-0.6

export PATH=$PWD/bin:$PATH

kubectl apply -f install/kubernetes/istio-auth.yaml
```
 At this point thats it...done
 can now install applications etc..
 we can add more plugins..

 lets add automatic sidecar injector webhook..
 Kubernetes CA approval permissions to create and approve CSR.
```
./install/kubernetes/webhook-create-signed-cert.sh  --service istio-sidecar-injector --namespace istio-system --secret sidecar-injector-certs
```

 now to install the sidercar injection configmap
```
kubectl apply -f install/kubernetes/istio-sidecar-injector-configmap-release.yaml

cat install/kubernetes/istio-sidecar-injector.yaml | ./install/kubernetes/webhook-patch-ca-bundle.sh > install/kubernetes/istio-sidecar-injector-with-ca-bundle.yaml
```
 install the sidecar injector webhook
`kubectl apply -f install/kubernetes/istio-sidecar-injector-with-ca-bundle.yaml`

 sidecar should now be visible
`kubectl -n istio-system get deployment -listio=sidecar-injector`

 adding tracing with zipkin.
`kubectl apply -f install/kubernetes/addons/zipkin.yaml`

 Access the dashboard with the following:
```
kubectl port-forward -n istio-system $(kubectl get pod -n istio-system -l app=zipkin -o jsonpath='{.items[0].metadata.name}') 9411:9411 &

open  http://localhost:9411
```

 prometheus
`kubectl apply -f install/kubernetes/addons/prometheus.yaml`


 to collect the telemetry you need yo add some stuff...not included here......yet..

adding graphana..
`kubectl apply -f install/kubernetes/addons/grafana.yaml`

 view the dashboard here..
 
```
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3000:3000 &

open http://localhost:3000/dashboard/db/istio-dashboard
```

 To view a graphical representation of your service mesh, install the Servicegraph add-on

```
kubectl apply -f install/kubernetes/addons/servicegraph.yaml

kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=servicegraph -o jsonpath='{.items[0].metadata.name}') 8088:8088 &   

open http://localhost:8088/dotviz
```

 kubernetes..
 from the kube internet...?

--more stuff
so auto sidecar injection does not seem to work as detailed about, so you need to do it manually..

- Option A
```
./bin/istioctl kube-inject -f samples/httpbin/httpbin.yaml| kubectl create -f -

cat <<EOF | kubectl create -f -
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: simple-ingress
  annotations:
    kubernetes.io/ingress.class: istio
spec:
  rules:
  - http:
      paths:
      - path: /status/.*
        backend:
          serviceName: httpbin
          servicePort: 8000
      - path: /delay/.*
        backend:
          serviceName: httpbin
          servicePort: 8000
EOF
```

The other option is to create an 'injected' yaml file for the application..

```
kubectl create -f install/kubernetes/istio-sidecar-injector-configmap-release.yaml \
    --dry-run \
    -o=jsonpath='{.data.config}' > inject-config.yaml
    
kubectl -n istio-system get configmap istio -o=jsonpath='{.data.mesh}' > mesh-config.yaml

istioctl kube-inject \
    --injectConfigFile inject-config.yaml \
    --meshConfigFile mesh-config.yaml \
    --filename application-file.yaml \
    --output application-file-injected.yaml
    
 kubectl apply -f application-file-injected.yaml    
```

