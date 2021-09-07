#!/bin/sh
echo "Escolha uma das opções abaixo..."
echo
echo "1 - Iniciar"
echo "2 - Desligar"
echo "3 - Apagar"
echo "0 - Sair"
echo
while :
do
  read INPUT_STRING
  case $INPUT_STRING in
    1)
      echo "Iniciando, aguarde a conclusão..."
      vagrant up
      break
      ;;
    2)
      echo "Desligando, aguarde a conclusão..."
      vagrant halt
      break
      ;;
    3)
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
