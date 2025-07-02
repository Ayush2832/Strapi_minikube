


- For manual deployment I follow this video
> [link](https://www.youtube.com/watch?v=aiMl6hM538w)
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