# Sistema NFS Linux via AWS
Este trabalho tem como objetivo a criação de uma instância AWS Linux com um servidor apache. Após isso, deve ser feito um script a fim de validar o funcionamento do serviço apache automaticamente.

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
![Inbound rules](https://github.com/vitortoniolo/pb_atividade_awslinuxnfs/assets/133904035/777c3b91-d561-4506-87a7-bd4e9c4a5750)


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
5. Seleciona a instância previamente criada

#### Linux (very wip)
1. clique connect na instancia ec2
2. ao abrir o terminal, digite "sudo yum update"
3. use o comando sudo mkdir nfs/<seunome> para criar o diretorio nfs
4. use o comando sudo nano /etc/exports (alternativamente pode usar vim invés de nano, por simplicidade irei usar nano) 
5. adicione a seguinte linha ao arquivo: /nfs/<seunome> <ipdamaquina>(rw,sync,no_root_squash,no_all_squash) 

 
