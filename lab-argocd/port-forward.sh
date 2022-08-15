#!/bin/bash

echo "Port forwarding the ArgoCD port. To acces the UI, connect to https://localhost:8080" 

kubectl port-forward svc/argocd-server -n argocd 8080:443
