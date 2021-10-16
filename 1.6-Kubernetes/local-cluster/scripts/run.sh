#!/bin/sh
echo "Choose one of the options below..."
echo
echo "1 - Turn on"
echo "2 - Turn off"
echo "3 - Delete"
echo "0 - Exit"
echo
while :
do
  read INPUT_STRING
  case $INPUT_STRING in
    1)
      echo "Starting, wait for completion..."
      vagrant box update && vagrant up
      break
      ;;
    2)
      echo "Hanging up, wait for completion..."
      vagrant halt
      break
      ;;
    3)
      echo "Deleting, confirm and wait for completion..."
      vagrant destroy -f
      break
      ;;
    0)
      break
      ;;
    *)
      echo "Invalid option"
      ;;
  esac
done
echo
echo "Completed"
