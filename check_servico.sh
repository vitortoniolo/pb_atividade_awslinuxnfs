#!/bin/bash

# Defina o nome do serviço a ser verificado
servico="httpd"  

# Verifica o status do serviço
systemctl is-active "$servico"
status=$?

# Obtém a data atual
data=$(date +"%H:%M_%d-%m-%Y")

# Define a mensagem personalizada
mensagem_online="O serviço $servico está online! :)"
mensagem_offline="O serviço $servico está offline :("

# Define o nome do arquivo com base no status
if [ $status -eq 0 ]; then
  status_nome="online"
  mensagem=$mensagem_online
else
  status_nome="offline"
  mensagem=$mensagem_offline
fi

# Cria o diretório e arquivo com as informações
mkdir -p /nfs/<seunome>/$data
echo "Data: $data" > "/nfs/<seunome>/$data/$status_nome.txt"
echo "Status: $mensagem" >> "/nfs/<seunome>/$data/$status_nome.txt"