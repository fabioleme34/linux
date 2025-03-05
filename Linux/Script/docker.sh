#!/bin/bash/

ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
#ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
#ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo  apt update
#ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo  apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
#ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo  docker --version
#ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo  systemctl enable docker
#ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo  systemctl status docker
#ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo systemctl stop docker
#ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo systemctl restart docker

