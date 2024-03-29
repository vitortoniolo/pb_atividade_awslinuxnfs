# Sistema NFS Linux via AWS
Este trabalho tem como objetivo a criação de uma instância AWS Linux com um servidor apache e montagem de um diretório NFS via um Elastic IP. Após isso, deve ser feito um script a fim de validar o funcionamento do serviço apache automaticamente e enviar os resultados para o diretório NFS.

#### Requisitos AWS
- Chave pública para o acesso à instância
- Instância EC2 com sistema operacional Amazon Linux 2 (t3.small e
16 GB SSD)
- Elastic IP anexado à instância
- Liberar seguintes portas de comunicação para acesso público:
  - 22/TCP
  - 111/TCP e UDP
  - 2049/TCP e UDP
  - 80/TCP 
  - 443/TCP

#### Requisitos Linux
- Configurar o NFS entregue
- Criar um diretorio dentro do filesystem do NFS
- Inicializar o apache
- Criar um script que deve ser executado automaticamente a cada 5 minutos
  - O script deve conter - Data/HORA + nome do serviço + Status + mensagem
personalizada de ONLINE ou offline
  - O script deve gerar 2 arquivos de saida: 1 para o serviço online e 1 para o serviço
OFFLINE

## Instruções passo-a-passo

#### Criação do Key Pair
1. No Dashboard EC2, entre na aba "Key Pairs" 
2. Clique em "Create Key Pair"
3. Nomeie sua chave
4. Nas caixas de opções, selecione "RSA" e ".pem" e prossiga 
5. O download de sua chave iniciará automaticamente, tenha certeza de salva-lá em um lugar seguro

#### Criação do security group
1. No Dashboard EC2, entre na aba "Security Groups"
2. Clique em "Create Security Group"
3. Nomeie e edite a descrição caso necessário
4. Em "Inbound rules", edite conforme a imagem:

#### Criação da Instância
1. No Dashboard EC2, entre na aba "Instances"
2. Clique em "Launch Instances"
3. Adicione Tags caso necessário
4. Para a AMI, selecione Amazon Linux 2
5. No tipo de instância, selecione t3.small
6. Em Key Pair, selecione a chave previamente criada
7. Em Security Group, selecione o grupo previamente criado
8. Em Storage, mude o disco para 16 GB e GP2
9. Clique em "Launch Instance"

#### Criação do Elastic IP
1. No Dashboard EC2, entre na aba  "Elastic IPs"
2. Selecione a mesma região e sua instância (provavelmente us-east-1)
3. Clique em Allocate
4. Selecione o IP,  clique em "Actions" e em "Associate Elastic IP"
5. Selecione a instância previamente criada

#### NFS 
1. Na aba de EFS, clique em "Create Filesystem"
2. Nomeie "NFS" e escolhe o VPC padrão
3. Após criar, selecione o file system e clique em "view details"
4. Navegue até a aba "Network" e clique em "Manage"
5. Mude todos os security groups para o mesmo que foi utilizado na instância
6. Ainda na tela do seu filesystem, clique em "Attach"
7. Em "Mount via DNS", copie o comando de "Using the NFS client:" , ele irá parecer assim:
`sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-05118e16cc9f62a18.efs.us-east-1.amazonaws.com:/ efs`
8. Certifique-se de mudar o diretorio default para o nosso diretorio nfs e execute
9. Verifique se está instalado corretamente com o df -h
10. Para automatizar a instalação do NFS, abra o fstab com o comando "sudo nano /etc/fstab"
11. Adicione a seguinte linha: `fs-05118e16cc9f62a18.efs.us-east-1.amazonaws.com:/  /nfs  nfs defaults 0 0`
12. A montagem deve ocorrer automaticamente ao reinicializar o sistema. Caso não ocorra, você pode executar "sudo mount -a" para executar o fstab manualmente

#### Apache
1. No CMD digite "sudo yum install httpd" para instalar o serviço apache
2. Após isso digie "sudo systemctl start httpd" para inicializa-lo
3. Para fazer o apache inicializar automaticamente, digite "sudo systemctl enable httpd"

#### Script
1. Digite "sudo mkdir scripts" para criar uma pasta para os scripts
2. Digite "sudo nano check_apache" 
3. Coloque o seguinte código (Certifique-se de mudar o nome do diretorio):

```shell
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
```

4. Conceda permissão para executar com "sudo chmod 777 check_servico.sh". Você pode testar o funcionamento com "sudo ./check_servico.sh
5. Digite "sudo crontab -e"
6. Adicione a seguinte linha:` */5 * * * * /scripts/check_servico.sh`
7. Caso esteja no VIM, salve apertando esc e em seguida ":w" 

#### Opcional: Conectar-se a instância via SSH no Windows ou Linux
1. Abrindo seu cmd, localize sua chave privada
2. Digite o seguinte comando: `ssh -i "<nomedachave>.pem" ec2-user@<dns ipv4 publico da sua instância>`


## Finalização
Agora sua instância está com o apache instalado, com o script rodando e enviando os logs para seu diretório NFS. O script está disponível no repositório para download.

![compass-uol](https://github.com/vitortoniolo/pb_atividade_awslinuxnfs/assets/133904035/a98c23e1-6502-4427-873b-71e8d32ae9bd)

 
