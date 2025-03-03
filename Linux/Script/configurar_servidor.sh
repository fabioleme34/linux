#!/bin/bash

# funçõe para atualizar o servidor baseado na distribuição
atualizar_servidor() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case $ID in
            ubuntu|debian)
                sudo apt-get update -y
                sudo apt-get upgrade -y
                ;;
            rhel|centos|ol)
                sudo yum update -y
                ;;
            *)
                echo "Distribuição não suportada."
                exit 1
                ;;
        esac
    else
        echo "Não foi possível identificar a distribuição."
        exit 1
    fi
}

# Instalar Apache2 e Unzip
instalar_pacotes() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case $ID in
            ubuntu|debian)
                sudo apt-get install -y apache2 unzip
                ;;
            rhel|centos|ol)
                sudo yum install -y httpd unzip
                sudo systemctl start httpd
                sudo systemctl enable httpd
                ;;
            *)
                echo "Distribuição não suportada."
                exit 1
                ;;
        esac
    else
        echo "Não foi possível identificar a distribuição."
        exit 1
    fi
}

# Baixar a aplicação do GitHub
baixar_aplicacao() {
    wget -O /tmp/main.zip https://github.com/denilsonbonatti/linux-site-dio/archive/refs/heads/main.zip
    unzip /tmp/main.zip -d /tmp/
}

# Copiar os arquivos da aplicação para o diretório padrão do Apache
copiar_arquivos() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case $ID in
            ubuntu|debian)
                sudo cp -r /tmp/linux-site-dio-main/* /var/www/html/
                ;;
            rhel|centos|ol)
                sudo cp -r /tmp/linux-site-dio-main/* /var/www/html/
                ;;
            *)
                echo "Distribuição não suportada."
                exit 1
                ;;
        esac
    else
        echo "Não foi possível identificar a distribuição."
        exit 1
    fi
}
# Função para perguntar se deseja subir os arquivos
perguntar_subir_arquivos() {
    read -p "Você deseja subir arquivos para o GitHub? (sim/nao): " resposta
    if [[ "$resposta" == "sim" ]]; then
        # Pede o diretório local do repositório GitHub
        read -p "Digite o diretório local do repositório GitHub: " diretorio_local
        if [[ ! -d "$diretorio_local" ]]; then
            echo "O diretório $diretorio_local não existe."
            return
        fi

        # Pede o diretório da web para transferir os arquivos
        read -p "Digite o diretório da web de onde os arquivos serão copiados: " diretorio_web
        if [[ ! -d "$diretorio_web" ]]; then
            echo "O diretório $diretorio_web não existe."
            return
        fi

        # Pergunta se deseja copiar os arquivos
        read -p "Você tem certeza que deseja copiar os arquivos de $diretorio_web para $diretorio_local? (sim/nao): " copiar
        if [[ "$copiar" == "sim" ]]; then
            # Copia os arquivos do diretório web para o diretório do repositório GitHub
            for item in "$diretorio_web"/*; do
                if [[ -d "$item" ]]; then
                    # Se for um diretório, copia o conteúdo
                    cp -r "$item" "$diretorio_local/"
                else
                    # Se for um arquivo, copia normalmente
                    cp "$item" "$diretorio_local/"
                fi
            done
            echo "Arquivos copiados com sucesso!"
        else
            echo "Operação cancelada."
        fi
    else
        echo "Operação cancelada."
    fi
}


# Executar as funções
atualizar_servidor
instalar_pacotes
baixar_aplicacao
copiar_arquivos
perguntar_subir_arquivos

echo "Processo concluído com sucesso!"
