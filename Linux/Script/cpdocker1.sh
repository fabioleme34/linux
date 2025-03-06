#!/bin/bash

# Caminho para o arquivo de chave privada
KEY_PATH="/home/fabiol/Documentos/01.pem"

# Usuário da instância EC2 (para a maioria das AMIs Ubuntu, o usuário é 'ubuntu')
USER="ubuntu"

# Caminho para armazenar o IP público salvo
IP_FILE="/home/fabiol/.last_aws_ip"

# Função para conectar via SSH
connect_ssh() {
    echo "Conectando-se à instância EC2 com IP $1..."
    ssh -i $KEY_PATH $USER@$1
}

# Função para verificar e corrigir fuso horário e hora
fix_time_and_timezone() {
    TIMEZONE="America/Sao_Paulo"

    # Atualizar os repositórios
    echo "Atualizando os repositórios do sistema..."
    sudo apt update -y

    # Instalar o pacote de timezone (caso não esteja instalado)
    echo "Instalando o pacote de timezone..."
    sudo apt install -y tzdata

    # Verificar o status atual do fuso horário
    current_timezone=$(timedatectl | grep "Time zone" | awk '{print $3}')

    # Comparar o fuso horário atual com o desejado
    if [ "$current_timezone" != "$TIMEZONE" ]; then
        echo "Fuso horário atual ($current_timezone) está incorreto. Alterando para $TIMEZONE..."
        sudo timedatectl set-timezone $TIMEZONE
    else
        echo "Fuso horário já está configurado corretamente como $TIMEZONE."
    fi

    # Ativar a sincronização de hora usando NTP (Network Time Protocol)
    echo "Ativando a sincronização de hora via NTP..."
    sudo timedatectl set-ntp true

    # Verificar a hora e o fuso horário do sistema
    echo "Verificando a hora e o fuso horário atual:"
    timedatectl

    # Verificar a hora do sistema
    current_time=$(timedatectl | grep "Local time" | awk '{print $3, $4, $5}')
    current_utc_time=$(timedatectl | grep "Universal time" | awk '{print $4, $5, $6}')
    echo "Hora local atual: $current_time"
    echo "Hora UTC: $current_utc_time"

    # Verificar se a hora está sincronizada corretamente com NTP
    ntp_status=$(timedatectl | grep "NTP synchronized" | awk '{print $3}')
    if [ "$ntp_status" != "yes" ]; then
        echo "A hora não está sincronizada corretamente com NTP. Forçando a sincronização..."
        sudo timedatectl set-ntp true
    else
        echo "A hora está sincronizada corretamente com NTP."
    fi

    # Exibir a hora final após as verificações
    echo "Hora final do sistema:"
    date
}

# Função para copiar o script docker.sh para o servidor EC2
copy_docker_script() {
    echo "Copiando o arquivo docker.sh para o servidor EC2..."
    scp -i $KEY_PATH /home/fabiol/Documentos/GitHub/linux/Linux/Script/docker.sh $USER@$1:/home/$USER/

    # Movendo o arquivo para a pasta /scripts/
    echo "Movendo o arquivo docker.sh para a pasta /scripts/..."
    ssh -i $KEY_PATH $USER@$1 "sudo mv /home/$USER/docker.sh /scripts/"

    # Concedendo permissões de execução para o arquivo docker.sh
    echo "Concedendo permissões de execução ao arquivo docker.sh..."
    ssh -i $KEY_PATH $USER@$1 "sudo chmod +x /scripts/docker.sh"
}

# Verificar se o arquivo que contém o IP anterior existe
if [ -f "$IP_FILE" ]; then
    # Ler o IP salvo
    LAST_IP=$(cat $IP_FILE)
    echo "IP público salvo anteriormente: $LAST_IP"

    # Solicitar ao usuário se o IP mudou
    echo "O IP público mudou? (s/n)"
    read CHANGE_IP

    if [ "$CHANGE_IP" == "s" ]; then
        # Solicitar o novo IP se o usuário informar que mudou
        echo "Por favor, insira o novo IP público da instância EC2:"
        read EC2_IP

        # Verificar se o IP foi fornecido
        if [ -z "$EC2_IP" ]; then
            echo "Erro: IP público não fornecido!"
            exit 1
        fi

        # Salvar o novo IP no arquivo
        echo $EC2_IP > $IP_FILE
    else
        # Usar o IP salvo se não tiver mudado
        EC2_IP=$LAST_IP
    fi
else
    # Se o arquivo não existir, pedir o IP pela primeira vez
    echo "Este é o primeiro uso. Por favor, insira o IP público da instância EC2:"
    read EC2_IP

    # Verificar se o IP foi fornecido
    if [ -z "$EC2_IP" ]; then
        echo "Erro: IP público não fornecido!"
        exit 1
    fi

    # Salvar o IP fornecido no arquivo
    echo $EC2_IP > $IP_FILE
fi

# Conectar via SSH
connect_ssh $EC2_IP

# Corrigir fuso horário e hora
fix_time_and_timezone

# Copiar o script docker.sh para o servidor EC2, mover para /scripts/ e conceder permissões de execução
copy_docker_script $EC2_IP

