#!/bin/sh
echo "Escolha uma das opções abaixo..."
echo
echo "1 - Iniciar"
echo "2 - Conexão SSH"
echo "3 - Desligar"
echo "4 - Apagar"
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
      echo "Iniciando a conexão com servidor, aguarde..."
      vagrant ssh
      break
      ;;
    3)
      echo "Desligando, aguarde a conclusão..."
      vagrant halt
      break
      ;;
    4)
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
