#!/bin/bash

# Função para atualizar o servidor baseado na distribuição
atualizar_servidor() {
    echo "Atualizando o servidor..."
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case $ID in
            ubuntu|debian)
                sudo apt-get update -y
                sudo apt-get upgrade -y
                if [ $? -ne 0 ]; then
                    echo "Erro ao atualizar o servidor."
                    exit 1
                fi
                ;;
            rhel|centos|ol)
                sudo yum update -y
                if [ $? -ne 0 ]; then
                    echo "Erro ao atualizar o servidor."
                    exit 1
                fi
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

# Função para instalar Apache2 e Unzip
instalar_pacotes() {
    echo "Instalando pacotes Apache2 e Unzip..."
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case $ID in
            ubuntu|debian)
                sudo apt-get install -y apache2 unzip
                if [ $? -ne 0 ]; then
                    echo "Erro ao instalar pacotes."
                    exit 1
                fi
                ;;
            rhel|centos|ol)
                sudo yum install -y httpd unzip
                if [ $? -ne 0 ]; then
                    echo "Erro ao instalar pacotes."
                    exit 1
                fi
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

# Função para baixar a aplicação do GitHub
baixar_aplicacao() {
    echo "Baixando a aplicação do GitHub..."
    wget -O /tmp/main.zip https://github.com/denilsonbonatti/linux-site-dio/archive/refs/heads/main.zip
    if [ $? -ne 0 ]; then
        echo "Erro ao baixar a aplicação."
        exit 1
    fi
    unzip /tmp/main.zip -d /tmp/
    if [ $? -ne 0 ]; then
        echo "Erro ao descompactar a aplicação."
        exit 1
    fi
}

# Função para copiar os arquivos da aplicação para o diretório padrão do Apache
copiar_arquivos() {
    echo "Copiando arquivos para o diretório do Apache..."
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case $ID in
            ubuntu|debian|rhel|centos|ol)
                sudo cp -r /tmp/linux-site-dio-main/* /var/www/html/
                if [ $? -ne 0 ]; then
                    echo "Erro ao copiar os arquivos."
                    exit 1
                fi
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

# Função para atualizar o repositório local do GitHub
atualizar_repositorio() {
    # Solicita o caminho do repositório local
    read -p "Digite o caminho do diretório local do repositório GitHub: " repo_dir
    if [[ ! -d "$repo_dir" ]]; then
        echo "O diretório local $repo_dir não existe."
        exit 1
    fi

    # Navega até o repositório local
    cd "$repo_dir" || exit

    # Verifica se é um repositório Git válido
    if [ ! -d ".git" ]; then
        echo "O diretório $repo_dir não é um repositório Git."
        exit 1
    fi

    # Solicita se deseja enviar as atualizações
    read -p "Você quer enviar as atualizações para o GitHub? (sim/não): " resposta
    if [[ "$resposta" == "sim" ]]; then
        # Adiciona as alterações
        git add .
        if [ $? -ne 0 ]; then
            echo "Erro ao adicionar os arquivos ao Git."
            exit 1
        fi

        # Faz o commit
        read -p "Digite a mensagem de commit: " mensagem_commit
        git commit -m "$mensagem_commit"
        if [ $? -ne 0 ]; then
            echo "Erro ao fazer o commit."
            exit 1
        fi

        # Envia as alterações para o repositório remoto
        git push origin main
        if [ $? -ne 0 ]; then
            echo "Erro ao enviar as alterações para o GitHub."
            exit 1
        fi

        echo "Atualizações enviadas com sucesso para o GitHub!"
    else
        echo "Operação cancelada. Nenhuma atualização foi enviada."
    fi
}



# Executar as funções
atualizar_servidor
instalar_pacotes
baixar_aplicacao
copiar_arquivos
atualizar_repositorio


echo "Processo concluído com sucesso!"
