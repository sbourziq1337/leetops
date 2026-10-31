#!/bin/bash
set -e

k3d cluster create iot-cluster

kubectl create namespace argocd
kubectl create namespace dev

kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

seleep 5

kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d; echo > passwd.txt

kubectl apply -a application.ymal

kubectl port-forward -n dev svc/leetops 8888:80

