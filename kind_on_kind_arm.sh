

#!/bin/bash
#
# 
#

set -oe errexit

# desired cluster name; default is "kind"
KIND_CLUSTER_NAME="kind"


echo "> initializing Kind cluster: ${KIND_CLUSTER_NAME}"

# create a cluster 
cat <<EOF | kind create cluster  --image rossgeorgiev/kind-node-arm64:v1.20.0 --name "${KIND_CLUSTER_NAME}" --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
        authorization-mode: "AlwaysAllow"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF

echo "> 😊😊 Verify Cluster install"

kubectl wait --for=condition=Ready=true node/kind-control-plane --timeout=30s

kubectl get nodes 

##
## Kong
##

echo "> 😊😊 Install Kong"📦

kubectl apply -f https://bit.ly/k4k8s

sleep 5

echo "> 😊😊 Verify Kong install"

kubectl get ns

sleep 5

kubectl get pods -n kong



echo "> 😊😊 done!"
