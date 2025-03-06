#!/bin/bash/

 sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
 sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
 sudo  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
 sudo  apt update
 sudo  apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
 sudo  docker --version
 sudo  systemctl enable docker
 sudo  systemctl status docker
 sudo systemctl stop docker
 sudo systemctl restart docker
 sudo mkdir -p /var/lib/docker/volumes/app  /var/lib/docker/volumes/app/_app  /var/lib/docker/volumes/data  /var/lib/docker/volumes/data/_data	
