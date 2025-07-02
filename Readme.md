# Running Strapi on Minikube


- For manual deployment I follow this video
> [link](https://www.youtube.com/watch?v=aiMl6hM538w)

- First I did whole thing manually. Using these commads
```
> commands used while testing

ayush@VM1:~$ kubectl expose pod strapiapp --type=NodePort --port=1337 --name=strapiapp-service 
service/strapiapp-service exposed

ayush@VM1:~$ kubectl get services
NAME                TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
kubernetes          ClusterIP   10.96.0.1      <none>        443/TCP          175m
strapiapp-service   NodePort    10.106.95.31   <none>        1337:32668/TCP   5s

ayush@VM1:~$ kubectl port-forward svc/strapiapp-service 30080:1337 --address 0.0.0.0 &
```

- For kubectl wait command I follow this blog
> [link](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_wait/)

- Then write the [command.sh](./terraform/command.sh)
```bash
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
```

- Then simply write terraform files to configure infrastructure
    - ec2.tf - for the creation of ec2
    - vpc.tf - for creation vpc

- Then finally the github acitions workflow
```yml
name: Running strapi on minikube

on:
    push:
        branches: master


jobs:
    minikube-deploy:
        runs-on: ubuntu-latest

        steps:
            - name: checkout the code
              uses: actions/checkout@v4

            - name: terraform setup
              uses: hashicorp/setup-terraform@v3

            - name: terraform init
              run: terraform init
              working-directory: ./terraform

            - name: terraform apply
              run: terraform apply --auto-approve
              working-directory: ./terraform
              env:
               AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
               AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

            - name: Get artifact
              uses: actions/upload-artifact@v4
              with:
                name: terroform.tfstate state file 
                path: ./terraform/terraform.tfstate
```
- And for secrets it defined on githb repo secrets in settings.