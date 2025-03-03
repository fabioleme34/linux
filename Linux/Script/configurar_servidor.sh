#!/bin/bash

# Função para atualizar o servidor baseado na distribuição
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

# Função para instalar Apache2 e Unzip
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

# Função para baixar a aplicação do GitHub
baixar_aplicacao() {
    wget -O /tmp/main.zip https://github.com/denilsonbonatti/linux-site-dio/archive/refs/heads/main.zip
    unzip /tmp/main.zip -d /tmp/
}

# Função para copiar os arquivos da aplicação para o diretório padrão do Apache
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


# Executar as funções
atualizar_servidor
instalar_pacotes
baixar_aplicacao
copiar_arquivos
perguntar_subir_arquivos

# Pergunta o caminho do diretório local e do repositório GitHub
read -p "Digite o caminho do diretório local do repositório GitHub: " repo_dir
if [[ ! -d "$repo_dir" ]]; then
    echo "O diretório local $repo_dir não existe."
    exit 1
fi

read -p "Digite o caminho do diretório do repositório GitHub: " github_dir
if [[ ! -d "$github_dir" ]]; then
    echo "O diretório do repositório GitHub $github_dir não existe."
    exit 1
fi

# Pergunta se deseja enviar as atualizações para o GitHub
read -p "Você quer enviar as atualizações para o GitHub? (sim/não): " resposta

# Verifica a resposta do usuário
if [[ "$resposta" == "sim" ]]; then
  # Navega até o repositório local
  cd "$repo_dir" || exit

  # Adiciona as alterações,
  git add .
  git commit -m "Atualizando repositório"
  git push origin main --force
  echo "Atualizações enviadas com sucesso!"
else
  echo "Atualizações não enviadas."
fi



echo "Processo concluído com sucesso!"
