# Terraform

## Cria chaves SSH
```bash
$ ssh-keygen -f terraform-aws -t rsa
```

## Teste acessando via SSH
```bash
$ ssh -i ~/.ssh/terraform-aws ubuntu@ec2-100-26-147-108.compute-1.amazonaws.com
```

## Comandos Terraform
```bash
$ terraform validate
$ terraform plan
$ terraform apply
$ terraform show
$ terraform destroy
$ terraform destroy -target aws_dynamodb_table.dynamodb-homologacao
```

## Comandos AWS
```bash
$ aws ec2 describe-security-groups
```

## Documentação
[Provider AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
