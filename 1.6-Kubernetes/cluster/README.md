# Cluster

Load Balancer (metallb): 192.168.0.20

```bash
$ ssh-keygen -t rsa
$ lsmod | grep br_netfilter
```

## Images

### List Images
```bash
$ sudo kubeadm config images list
```

### Pull images
```bash
$ for image in k8s.gcr.io/kube-apiserver:v1.22.2 \
k8s.gcr.io/kube-controller-manager:v1.22.2 \
k8s.gcr.io/kube-scheduler:v1.22.2 \
k8s.gcr.io/kube-proxy:v1.22.2 \
k8s.gcr.io/pause:3.5 \
k8s.gcr.io/etcd:3.5.0-0 \
k8s.gcr.io/coredns/coredns:v1.8.4; do
sudo docker pull $image;
done
```

### Save images
```bash
$ mkdir /vagrant/k8s-images
$ docker save k8s.gcr.io/kube-apiserver:v1.22.2 > /vagrant/k8s-images/kube-apiserver.tar
$ docker save k8s.gcr.io/kube-controller-manager:v1.22.2 > /vagrant/k8s-images/kube-controller-manager.tar
$ docker save k8s.gcr.io/kube-scheduler:v1.22.2 > /vagrant/k8s-images/kube-scheduler.tar
$ docker save k8s.gcr.io/kube-proxy:v1.22.2 > /vagrant/k8s-images/kube-proxy.tar
$ docker save k8s.gcr.io/pause:3.5 > /vagrant/k8s-images/pause.tar
$ docker save k8s.gcr.io/etcd:3.5.0-0 > /vagrant/k8s-images/etcd.tar
$ docker save k8s.gcr.io/coredns/coredns:v1.8.4 > /vagrant/k8s-images/coredns.tar
```

### Load images
```bash
$ cd /vagrant/k8s-images
$ ls /vagrant/k8s-images/* | while read image; do docker load < $image; done
```

## Node master tests
```bash
$ kubectl cluster-info
$ watch kubectl get pods --all-namespaces
$ watch kubectl get nodes -o wide
$ kubectl api-resources -o wide
```

## Local machine tests
```bash
cat /etc/hosts
192.168.0.20    whoami.worksit.com.br
192.168.0.20    dash.worksit.com.br
192.168.0.20    grafana.worksit.com.br
192.168.0.20    prometheus.worksit.com.br
192.168.0.20    alertmanager.worksit.com.br
```

## Dashboard
```bash
$ wget https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
$ kubectl apply -f /vagrant/services/kube-dash/deploy.yml
$ kubectl apply -f /vagrant/services/kube-dash/dash.yml
$ kubectl get services -n kubernetes-dashboard
$ kubectl get deployments -n kubernetes-dashboard
$ kubectl get pods -n kubernetes-dashboard
$ kubectl describe ingress -n kubernetes-dashboard
$ SA_NAME="devops-admin"
$ kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep ${SA_NAME} | awk '{print $1}')
```

## Demo
```bash
$ kubectl apply -f /vagrant/services/whoami/deploy.yml
$ kubectl get services -n whoami
$ kubectl get deployments -n whoami
$ kubectl get pods -n whoami
$ kubectl describe ingress -n whoami
```

## Monitoring

```bash
$ git clone https://github.com/prometheus-operator/kube-prometheus.git
$ kubectl create -f /vagrant/services/kube-prometheus/manifests/setup
$ kubectl get ns monitoring
$ kubectl get pods -n monitoring
$ kubectl create -f /vagrant/services/kube-prometheus/manifests
```

### Grafana Dashboard
Username: admin
Password: admin
```bash
$ kubectl get svc -n monitoring -o wide
$ kubectl apply -f /vagrant/services/kube-prometheus/grafana.yml
```

### Prometheus Dashboard
```bash
$ kubectl get svc -n monitoring -o wide
$ kubectl apply -f /vagrant/services/kube-prometheus/prometheus.yml
```

### Alert Manager Dashboard
```bash
$ kubectl get svc -n monitoring -o wide
$ kubectl apply -f /vagrant/services/kube-prometheus/alertmanager.yml
```
