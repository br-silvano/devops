# metrics-server

```bash
$ wget https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
$ kubectl get deployment metrics-server -n kube-system
$ kubectl get pods -n kube-system | grep metrics
$ kubectl get apiservice v1beta1.metrics.k8s.io -o yaml
$ kubectl top --help
$ kubectl top nodes
$ kubectl top pods -A
$ kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes" | jq
$ kubectl top pod --help
$ kubectl top node --help
```
