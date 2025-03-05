#!/bin/bash

# Atualizar pacotes
sudo apt update

# Instalar MySQL
sudo apt install -y mysql-server

# Iniciar o MySQL
sudo systemctl start mysql

# Habilitar MySQL para iniciar no boot
sudo systemctl enable mysql

# Gerar localidades necessárias
sudo locale-gen pt_BR.UTF-8

# Atualizar a localidade para pt_BR.UTF-8
sudo update-locale LANG=pt_BR.UTF-8

# Editar o arquivo /etc/default/locale se necessário
echo 'LANG="pt_BR.UTF-8"' | sudo tee /etc/default/locale

# Acessar MySQL e executar os comandos
sudo mysql -e "
-- Criar banco de dados apenas se não existir
CREATE DATABASE IF NOT EXISTS mel;

-- Usar o banco de dados
USE mel;

-- Criar tabela com os campos nome, telefone, endereco e cidade
CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    telefone VARCHAR(15),
    endereco VARCHAR(255),
    cidade VARCHAR(100)
);

"

echo "Banco de dados 'mel' e a tabela 'clientes' foram criados com sucesso!"

sudo reboot
