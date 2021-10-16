
## Deployment

### portal-noticias-deployment
```bash
$ kubectl rollout history deployment portal-noticias-deployment
$ kubectl annotate deployment portal-noticias-deployment kubernetes.io/change-cause="Criando portal de notícias na versão 1"
$ kubectl rollout history deployment portal-noticias-deployment
```

### portal-noticias-deployment
```bash
$ kubectl rollout history deployment portal-noticias-deployment
$ kubectl annotate deployment sistema-noticias-deployment kubernetes.io/change-cause="Subindo o sistema na versão 1"
$ kubectl rollout  history deployment sistema-noticias-deployment
```

### db-noticias-deployment
```bash
$ kubectl rollout history deployment db-noticias-deployment
$ kubectl annotate deployment db-noticias-deployment kubernetes.io/change-cause="Subindo o banco na versão 1"
$ kubectl rollout history deployment db-noticias-deployment
```

### Voltar um Deployment para uma revisão específica
```bash
$ kubectl rollout undo deployment <nome do deployment> --to-revision=<versão a ser retornada>
```

## Persistência de dados

```bash
$ kubectl apply -f /vagrant/src/pod-volume.yml
$ kubectl get pods
$ kubectl describe pod pod-volume
$ kubectl exec -it pod-volume --container nginx-container sh
$ kubectl exec -it pod-volume --container jenkins-container sh
```

### AWS
```bash
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
$ unzip awscliv2.zip
$ sudo ./aws/install
$ aws ec2 create-volume --availability-zone=us-east-1a --size=10 --volume-type=gp2
$ kubectl apply -f /vagrant/src/pv.yml
$ kubectl get pv
$ kubectl apply -f /vagrant/src/pvc.yml
$ kubectl get pvc
$ kubectl apply -f /vagrant/src/pod-pv.yml
$ kubectl get pods
$ kubectl describe pod pod-pv
```
