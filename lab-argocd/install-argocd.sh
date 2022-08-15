#!/bin/sh

# Script to Install ArgoCD 

set -e 
DIR=$(dirname $0) 

echo "🚀🚀 Creating ArgoCD Namespace"
kubectl create ns argocd || echo "namespace argocd exists" 

echo "🚀🚀 Installing ArgoCD"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "🚦 Waiting for ArgoCD server to be ready.\c"
until sleep 1; echo  ".\c"; kubectl get pods -l app.kubernetes.io/name=argocd-server -n argocd -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}' | grep -m 1 "True"; do : ; done
echo "🚦 Waiting for ArgoCD repo-server to be ready.\c"
until sleep 1; echo  ".\c"; kubectl get pods -l app.kubernetes.io/name=argocd-repo-server -n argocd -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}' | grep -m 1 "True"; do : ; done

ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "🚀🚀 ArgoCD is running! The admin password is: ${ARGOCD_PASSWORD}"

