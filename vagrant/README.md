# Vagrant: Gerenciando máquinas virtuais

## Infraestrutura como código (IaC)

>### Criar arquivo Vagrantfile
```bash
$ vagrant init ubuntu/bionic64
```

>### Criar / ligar máquina(s)
```bash
$ vagrant up
```

>### Destruir e criar / ligar máquina(s)
```bash
$ vagrant destroy -f && vagrant up
```

>### Verificar status da(s) máquina(s)
```bash
$ vagrant status
```

>### Desligar máquina(s)
```bash
$ vagrant halt
```

>### Reiniciar máquina(s)
```bash
$ vagrant reload
```

>### Destruir máquina(s)
```bash
$ vagrant destroy -f
```

>### Conexão SSH
```bash
$ vagrant ssh
$ ssh-keygen
$ rm /c/Users/User/.ssh/known_hosts
$ ssh -i bionic_rsa vagrant@192.168.0.5
```

### Boxes baixadas
```bash
$ vagrant box list
```

### Remover as boxes
```bash
$ vagrant box prune
$ vagrant box remove <nome>
```

### Listar todas as máquinas
```bash
$ vagrant global-status --prune
```

### Controlar a máquina virtual fora da pasta do projeto
```bash
$ vagrant destroy -f <ID-da-VM>
```

## Testes

### MySQL
```bash
$ vagrant ssh mysqldb
$ netstat -tlnp
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:3306            0.0.0.0:*               LISTEN      -
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      -
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      -
tcp6       0      0 :::22                   :::*                    LISTEN      -
$ ps aux | grep mysql
mysql     3533  0.1 17.6 1423836 177572 ?      Sl   13:08   0:07 /usr/sbin/mysqld --daemonize --pid-file=/run/mysqld/mysqld.pid
vagrant   3926  0.0  0.1  14864  1012 pts/0    S+   14:40   0:00 grep --color=auto mysql
$ mysql -u phpuser -p
```

### PHP
```bash
$ vagrant ssh phpweb
$ netstat -tlnp
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:8888            0.0.0.0:*               LISTEN      -
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      -
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      -
tcp6       0      0 :::80                   :::*                    LISTEN      -
tcp6       0      0 :::22                   :::*                    LISTEN      -
$ ps aux | grep php
root     11271  0.0  1.7 273888 17568 ?        S    14:29   0:00 /usr/bin/php -S 0.0.0.0:8888 -t /vagrant/src
vagrant  11699  0.0  0.1  14864  1048 pts/0    S+   14:41   0:00 grep --color=auto php
$ curl http://localhost:8888
```

## Requisitos
- [VirtualBox-6.1.26-145957-Win.exe](https://www.virtualbox.org/wiki/Downloads)
- [vagrant_2.2.18_x86_64.msi](https://www.vagrantup.com)
- [Vagrant Cloud](https://app.vagrantup.com)

## Documentação
- [Vagrant](https://www.vagrantup.com/docs)
