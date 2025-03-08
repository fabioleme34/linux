#!/bin/bash

# Função para verificar se o MySQL está instalado
check_mysql_installed() {
    dpkg -l | grep -i mysql &> /dev/null
    return $?
}

# Função para verificar se o MySQL está em execução
check_mysql_running() {
    # Tentando a conexão com o MySQL até 30 vezes, com intervalo de 2 segundos
    for i in {1..30}; do
        if sudo docker exec mysql-container mysqladmin -uroot -p"$MYSQL_ROOT_PASSWORD" ping > /dev/null 2>&1; then
            echo "MySQL está em execução!"
            return 0
        fi
        echo "Tentando conectar ao MySQL... (Tentativa $i de 30)"
        sleep 2
    done
    return 1
}

# Função para listar tabelas no banco de dados MySQL
list_tables() {
    sudo docker exec mysql-container mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "USE $DB_NAME; SHOW TABLES;" | tail -n +2
}

# Função para criar uma nova tabela
create_table() {
    echo "Criando uma nova tabela com os campos nome, email, endereco e telefone..."
    sudo docker exec mysql-container mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "
        USE $DB_NAME;
        CREATE TABLE IF NOT EXISTS contatos (
            id INT AUTO_INCREMENT PRIMARY KEY,
            nome VARCHAR(100) NOT NULL,
            email VARCHAR(100) NOT NULL,
            endereco VARCHAR(255),
            telefone VARCHAR(20)
        );
    "
    echo "Tabela 'contatos' criada com sucesso!"
}

# Instalar dependências necessárias
echo "Instalando dependências para Docker..."
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Baixar a chave GPG do Docker
echo "Baixando chave GPG do Docker..."
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

# Adicionar repositório Docker
echo "Adicionando repositório Docker..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualizar a lista de pacotes
echo "Atualizando pacotes..."
sudo apt update

# Instalar Docker
echo "Instalando Docker..."
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Verificar versão do Docker
echo "Verificando a versão do Docker..."
sudo docker --version

# Ativar e iniciar o Docker
echo "Ativando o Docker para iniciar automaticamente..."
sudo systemctl enable docker
sudo systemctl start docker

# Parar e reiniciar o Docker
echo "Parando e reiniciando o Docker..."
sudo systemctl stop docker
sudo systemctl start docker

# Verificar se o MySQL está instalado
if check_mysql_installed; then
    # Perguntar se o usuário deseja remover e reinstalar o MySQL
    echo "MySQL já está instalado no sistema. Deseja removê-lo e instalar novamente? (s/n)"
    read REMOVE_MYSQL
    if [ "$REMOVE_MYSQL" = "s" ] || [ "$REMOVE_MYSQL" = "S" ]; then
        echo "Removendo MySQL..."
        sudo apt-get remove --purge mysql* -y
        sudo apt-get autoremove -y
        sudo apt-get autoclean
        echo "MySQL removido com sucesso."
    else
        echo "MySQL não será removido. Continuando o script."
    fi
else
    echo "MySQL não está instalado. Prosseguindo com a instalação..."
fi

# Pedir ao usuário para digitar o nome do banco de dados e a senha do MySQL
echo "Por favor, digite o nome do banco de dados que deseja criar:"
read DB_NAME

echo "Por favor, digite a senha para o usuário root do MySQL:"
read MYSQL_ROOT_PASSWORD

# Instalar o MySQL no Docker
echo "Instalando o MySQL no Docker..."
sudo docker pull mysql:latest

# Verificar se o contêiner mysql-container já existe e removê-lo, se necessário
echo "Verificando se o contêiner mysql-container já existe..."
if sudo docker ps -a --filter "name=mysql-container" --format '{{.Names}}' | grep -q mysql-container; then
    echo "O contêiner mysql-container já existe. Removendo o contêiner existente..."
    sudo docker rm -f mysql-container
else
    echo "Nenhum contêiner mysql-container encontrado."
fi

# Criar e executar o contêiner do MySQL com base nas entradas do usuário
echo "Criando e executando o contêiner MySQL..."
sudo docker run --name mysql-container -e MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" -e MYSQL_DATABASE="$DB_NAME" -d mysql:latest

# Verificar se o MySQL está em execução
echo "Verificando se o MySQL está em execução..."
check_mysql_running
if [ $? -ne 0 ]; then
    echo "Erro ao conectar com o MySQL no Docker. Verifique o estado do contêiner."
    exit 1
fi

# Listar as tabelas no banco de dados
echo "Listando as tabelas no banco de dados $DB_NAME..."
tables=$(list_tables)

if [ -z "$tables" ]; then
    echo "Nenhuma tabela encontrada. Vamos criar uma nova tabela."
    create_table
else
    echo "Tabelas encontradas:"
    echo "$tables"
    echo "Escolha uma das opções abaixo:"
    echo "1. Usar uma tabela existente"
    echo "2. Remover uma tabela"
    echo "3. Criar uma nova tabela"
    read -p "Escolha uma opção (1/2/3): " option

    case $option in
        1)
            echo "Digite o nome da tabela que deseja usar:"
            read table_name
            echo "Você escolheu usar a tabela '$table_name'."
            # Aqui você pode adicionar qualquer lógica extra para interagir com a tabela escolhida
            ;;
        2)
            echo "Digite o nome da tabela que deseja remover:"
            read table_name
            echo "Removendo a tabela '$table_name'..."
            sudo docker exec mysql-container mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "USE $DB_NAME; DROP TABLE IF EXISTS $table_name;"
            echo "Tabela '$table_name' removida com sucesso!"
            ;;
        3)
            create_table
            ;;
        *)
            echo "Opção inválida. Saindo..."
            ;;
    esac
fi

# Verificar as tabelas novamente após qualquer ação
echo "Tabelas após a ação:"
list_tables
