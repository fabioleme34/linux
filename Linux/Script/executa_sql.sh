#!/bin/bash
#Faz a copia do instal_sql para o aws 01
scp -i /home/fabiol/Documentos/01.pem  /home/fabiol/Documentos/GitHub/linux/Linux/Script/install_sql.sh ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com:/home/ubuntu/
ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com
ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo mv /home/ubuntu/install_sql.sh /scripts/
ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo chmod +x /scripts/install_sql.sh
ssh -i /home/fabiol/Documentos/01.pem ubuntu@ec2-3-145-153-91.us-east-2.compute.amazonaws.com sudo /scripts/install_sql.sh
