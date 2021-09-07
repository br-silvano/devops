# Cluster

## Generate a new SSH key
```bash
$ mkdir configs
$ ssh-keygen -t rsa
```

## Login to the server to be used as master and make sure that the br_netfilter module is loaded
```bash
$ lsmod | grep br_netfilter
```

## Check cluster status
```bash
$ kubectl cluster-info
```

## Confirm that all of the pods are running
```bash
$ watch kubectl get pods --all-namespaces
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-58497c65d5-rmm72   1/1     Running   0          5m27s
kube-system   calico-node-72hgg                          1/1     Running   0          5m27s
kube-system   calico-node-m4nsr                          1/1     Running   0          2m46s
kube-system   coredns-78fcd69978-j5nfd                   1/1     Running   0          5m27s
kube-system   coredns-78fcd69978-wcmwz                   1/1     Running   0          5m27s
kube-system   etcd-k8s-m-1                               1/1     Running   0          5m44s
kube-system   kube-apiserver-k8s-m-1                     1/1     Running   0          5m41s
kube-system   kube-controller-manager-k8s-m-1            1/1     Running   0          5m41s
kube-system   kube-proxy-l6s8c                           1/1     Running   0          2m46s
kube-system   kube-proxy-mz8xr                           1/1     Running   0          5m27s
kube-system   kube-scheduler-k8s-m-1                     1/1     Running   0          5m41s
```

## Confirm master node is ready
```bash
$ kubectl get nodes -o wide
NAME      STATUS   ROLES                  AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION       CONTAINER-RUNTIME
k8s-m-1   Ready    control-plane,master   4m36s   v1.22.1   10.0.2.15     <none>        Ubuntu 18.04.5 LTS   4.15.0-154-generic   docker://20.10.7
k8s-w-1   Ready    <none>                 96s     v1.22.1   10.0.2.15     <none>        Ubuntu 18.04.5 LTS   4.15.0-154-generic   docker://20.10.7
```

## Docker login
```bash
$ docker login
```

## Docker registry
```bash
$ kubectl create secret generic registry-credential \
    --from-file=.dockerconfigjson=/home/vagrant/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson
```

## Test
```bash
$ kubectl create namespace nginx
$ kubectl create deployment nginx --image=nginx --namespace=nginx
$ kubectl get deployments --namespace=nginx
$ kubectl describe deployment nginx --namespace=nginx
$ kubectl create service nodeport nginx --tcp=80:80 --namespace=nginx
$ kubectl get svc --namespace=nginx
$ kubectl scale deployments nginx --replicas 4 --namespace=nginx
$ kubectl get deployments nginx --namespace=nginx
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   4/4     4            4           4m34s
$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-58497c65d5-rmm72   1/1     Running   0          12m
kube-system   calico-node-72hgg                          1/1     Running   0          12m
kube-system   calico-node-m4nsr                          1/1     Running   0          9m35s
kube-system   coredns-78fcd69978-j5nfd                   1/1     Running   0          12m
kube-system   coredns-78fcd69978-wcmwz                   1/1     Running   0          12m
kube-system   etcd-k8s-m-1                               1/1     Running   0          12m
kube-system   kube-apiserver-k8s-m-1                     1/1     Running   0          12m
kube-system   kube-controller-manager-k8s-m-1            1/1     Running   0          12m
kube-system   kube-proxy-l6s8c                           1/1     Running   0          9m35s
kube-system   kube-proxy-mz8xr                           1/1     Running   0          12m
kube-system   kube-scheduler-k8s-m-1                     1/1     Running   0          12m
nginx         nginx-6799fc88d8-7jj8d                     1/1     Running   0          73s
nginx         nginx-6799fc88d8-q6msm                     1/1     Running   0          5m14s
nginx         nginx-6799fc88d8-x8qlp                     1/1     Running   0          73s
nginx         nginx-6799fc88d8-zc9kb                     1/1     Running   0          73s
$ curl k8s-m-1:31307
```

## Container runtime sockets:
### Runtime: Path to Unix domain socket
- Docker:	/var/run/docker.sock
- containerd:	/run/containerd/containerd.sock
- CRI-O:	/var/run/crio/crio.sock
