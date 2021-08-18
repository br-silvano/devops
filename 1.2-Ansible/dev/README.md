# Ansible: Ambiente de desenvolvimento

## Teste inicial
```bash
$ ansible wordpress -u vagrant --private-key .vagrant/machines/wordpress/virtualbox/private_key -i hosts -m shell -a "echo Hello, World"
```

## Teste verboso
```bash
$ ansible -vvvv wordpress -u vagrant --private-key .vagrant/machines/wordpress/virtualbox/private_key -i hosts -m shell -a "echo Hello, World"
```

## Playbook
```bash
$ ansible-playbook provisioning.yml -u vagrant -i hosts --private-key .vagrant/machines/wordpress/virtualbox/private_key
$ ansible-playbook provisioning.yml -i hosts
```

## Provisionamento
```bash
$ chmod +x run.sh
$ ./run.sh
```
