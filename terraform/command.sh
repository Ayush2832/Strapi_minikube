#!/bin/bash
sudo apt update && sudo apt upgrade -y

# install docker 
curl -fsSL https://get.docker.com | sh
# and add the user to the docker group so it wont find any difficulty later

sudo usermod -aG docker $USER
newgrp docker

# install minikube and kubectl
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start

kubectl config use-context minikube


until kubectl get serviceaccount default >/dev/null 2>&1; do
  sleep 2
done

#run our strapi image 
kubectl run strapiapp --image=ayush2832/strapi3:v7 

kubectl wait --for=condition=Ready pod/strapiapp --timeout=300s

#expose network with nodeport service
kubectl expose pod strapiapp --type=NodePort --port=1337 --name=strapiapp-service

#forward the request from 80 to node port service 1337
kubectl port-forward svc/strapiapp-service 1337:1337 --address 0.0.0.0 & 
ayush@VM1:~$ 


