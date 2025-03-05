#!/bin/bash

# Copiar o script docker.sh para o servidor EC2
sudo scp -i /home/fabiol/Documentos/01.pem /home/fabiol/Documentos/GitHub/linux/Linux/Script/docker.sh ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com:/home/ubuntu/

# Mover o arquivo docker.sh para /scripts/
ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo mv /home/ubuntu/docker.sh /scripts/

# Conceder permissões de execução ao script
ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo chmod +x /scripts/docker.sh

# Executar o script
ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo sh /scripts/docker.sh

# Descomente a linha abaixo caso prefira rodar o script diretamente com o ./docker.sh
# ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com "sudo /scripts/docker.sh"






























#!/bin/bash
#Copia o script do docker
#scp -i /home/fabiol/Documentos/01.pem  /home/fabiol/Documentos/GitHub/linux/Linux/Script/docker.sh ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com:/home/ubuntu
#ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo mv /home/ubuntu/docker.sh /scripts/
#ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo chmod +x /scripts/docker.sh
#ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo bash  /scripts/docker.sh
#ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo ./docker.sh 

