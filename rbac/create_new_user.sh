#!/bin/bash

# Create key
openssl genrsa briancollins.key 2048

# Create csr
openssl req -new -key briancollins.key -out briancollins.csr -subj "/CN=briancollins/O=cka"

# Sign generated csr and make it available for 365days - using kubernetes cluster cert and key
openssl x509 -req -in briancollins.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out briancollins.crt -days 365

# Create the user in kubernetes cluster by 
# 1. Setting a user entry in kubeconfig for briancollins; point to the CRT and key file. 
# 2. Set a context entry in kubeconfig for briancollins
kubectl config set-credentials briancollins --client-certificate=briancollins.crt --client-key=briancollins.key
kubectl config set-context briancollins-context --user=briancollins --cluster=kubernetes 

# Create a role - read role for pods, services and eployments resources
kubectl create role read-only --verb=list,get,watch --resource=pods,services,deployments # --resource-name=pod-name,deployment-name

# Create a role binding
kubectl create rolebinding read-only-binding --role read-only --user briancollins

# Switch to the context and test it
kubectl config use-context briancollins-context
kubectl config current-context

