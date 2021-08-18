#!/bin/sh
echo "Escolha uma das opções abaixo..."
echo
echo "1 - Iniciar"
echo "2 - Conexão SSH MySQL"
echo "3 - Conexão SSH WordPress"
echo "4 - Desligar"
echo "5 - Apagar"
echo "0 - Sair"
echo
while :
do
  read INPUT_STRING
  case $INPUT_STRING in
    1)
      echo "Iniciando, aguarde a conclusão..."
      vagrant up && ansible-playbook provisioning.yml -i hosts
      break
      ;;
    2)
      echo "Iniciando a conexão com servidor MySQL, aguarde..."
      vagrant ssh mysql
      break
      ;;
    3)
      echo "Iniciando a conexão com servidor WordPress, aguarde..."
      vagrant ssh wordpress
      break
      ;;
    4)
      echo "Desligando, aguarde a conclusão..."
      vagrant halt
      break
      ;;
    5)
      echo "Apagando, confirme e aguarde a conclusão..."
      vagrant destroy
      break
      ;;
    0)
      break
      ;;
    *)
      echo "Opção inválida!"
      ;;
  esac
done
echo
echo "Concluído!"
