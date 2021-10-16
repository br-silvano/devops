# aws-eks

```bash
$ terraform init
$ terraform plan -var-file=test.tfvars
$ terraform apply -var-file=test.tfvars
$ aws eks --region us-east-2 update-kubeconfig --name demo-test
$ kubectl get pod --all-namespaces
$ kubectl get svc --all-namespaces
$ kubectl get deployment --all-namespaces
$ kubectl get replicaset --all-namespaces
$ kubectl get configmap --all-namespaces
$ kubectl get sc --all-namespaces
$ kubectl get pv --all-namespaces
$ kubectl get pvc --all-namespaces
$ terraform destroy -var-file=test.tfvars
```
