#!/bin/bash

# 1 Função para criar diretórios
criar_diretorios() {
    read -p "Quantos diretórios você deseja criar? " num_diretorios
    read -p "Qual o caminho onde os diretórios serão criados? " caminho

    for ((i=1; i<=num_diretorios; i++))
    do
        read -p "Qual o nome do diretório $i? " nome_dir

        # Pergunta se o diretório será criado no mesmo caminho ou em caminhos diferentes
        read -p "Criar o diretório $nome_dir no mesmo caminho ($caminho)? (s/n) " resposta
        if [ "$resposta" == "n" ]; then
            read -p "Digite o caminho para criar o diretório $nome_dir: " caminho_dir
        else
            caminho_dir="$caminho/$nome_dir"
        fi

        # Criação do diretório
        mkdir -p "$caminho_dir"
        echo "Diretório $caminho_dir criado com sucesso."

        # Pergunta se deseja adicionar um dono
        read -p "Deseja adicionar um dono para o diretório $nome_dir? (s/n) " adicionar_dono
        if [ "$adicionar_dono" == "s" ]; then
            read -p "Digite o nome do dono: " dono
            sudo chown $dono "$caminho_dir"
            echo "Dono $dono adicionado ao diretório $nome_dir."
        fi

        # Pergunta se deseja definir o dono como root
        read -p "Deseja criar o dono do diretório $nome_dir como root? (s/n) " dono_root
        if [ "$dono_root" == "s" ]; then
            sudo chown root "$caminho_dir"
            echo "Dono do diretório $nome_dir alterado para root."
        fi
    done
}

# 2 Função para deletar diretórios
deletar_diretorios() {
    read -p "Quantos diretórios você deseja deletar? " num_diretorios
    for ((i=1; i<=num_diretorios; i++))
    do
        read -p "Qual o nome do diretório $i a ser deletado? " nome_dir
        rm -rf "$nome_dir"
        echo "Diretório $nome_dir deletado com sucesso."
    done
}

# 3 Função para criar grupos
criar_grupos() {
    read -p "Quantos grupos você deseja criar? " num_grupos
    for ((i=1; i<=num_grupos; i++))
    do
        read -p "Qual o nome do grupo $i? " nome_grupo
        sudo groupadd "$nome_grupo"
        echo "Grupo $nome_grupo criado com sucesso."
    done
}

# 4 Função para deletar grupos
deletar_grupos() {
    read -p "Quantos grupos você deseja deletar? " num_grupos
    for ((i=1; i<=num_grupos; i++))
    do
        read -p "Qual o nome do grupo $i a ser deletado? " nome_grupo
        sudo groupdel "$nome_grupo"
        echo "Grupo $nome_grupo deletado com sucesso."
    done
}

# 5 Função para criar usuários
criar_usuarios() {
    read -p "Quantos usuários você deseja criar? " num_usuarios
    for ((i=1; i<=num_usuarios; i++))
    do
        read -p "Qual o nome do usuário $i? " nome_usuario
        sudo useradd -m "$nome_usuario"
        echo "Usuário $nome_usuario criado com sucesso."
    done
}

# 6 Função para deletar usuários
deletar_usuarios() {
    read -p "Quantos usuários você deseja deletar? " num_usuarios
    for ((i=1; i<=num_usuarios; i++))
    do
        read -p "Qual o nome do usuário $i a ser deletado? " nome_usuario

        # Verifica se o usuário existe
        if id "$nome_usuario" &>/dev/null; then
            sudo userdel -r "$nome_usuario"
            echo "Usuário $nome_usuario deletado com sucesso."
        else
            echo "Usuário $nome_usuario não existe."
        fi
    done
}

# 7 Função para adicionar usuários a grupos
adicionar_usuarios_a_grupos() {
    read -p "Quantos usuários você deseja adicionar a grupos? " num_usuarios
    for ((i=1; i<=num_usuarios; i++))
    do
        read -p "Digite o nome do usuário $i: " nome_usuario
        read -p "Digite o nome do grupo: " nome_grupo
        sudo usermod -aG "$nome_grupo" "$nome_usuario"
        echo "Usuário $nome_usuario adicionado ao grupo $nome_grupo."
    done
}

# 8 Função para adicionar usuários a diretórios como dono do Diretorio
adicionar_usuarios_a_diretorios() {
    read -p "Quantos usuários você deseja adicionar a diretórios? " num_usuarios
    for ((i=1; i<=num_usuarios; i++))
    do
        read -p "Digite o nome do usuário $i: " nome_usuario
        read -p "Digite o caminho do diretório: " caminho_dir

        # Verifica se o usuário e o diretório existem
        if id "$nome_usuario" &>/dev/null && [[ -d "$caminho_dir" ]]; then
            sudo chown "$nome_usuario" "$caminho_dir"
            echo "Usuário $nome_usuario adicionado como dono do diretório $caminho_dir."
        else
            echo "Usuário $nome_usuario ou diretório $caminho_dir não existe."
        fi
    done
}

# 9 Função para adicionar permissões de usuário a diretórios
adicionar_perm_usuarios() {
    read -p "Quantos usuários você deseja adicionar permissões em diretórios? " num_usuarios
    for ((i=1; i<=num_usuarios; i++))
    do
        read -p "Digite o nome do usuário $i: " nome_usuario
        read -p "Digite o caminho do diretório: " caminho_dir
        read -p "Digite as permissões (r--, rw-, r-x, rwx, etc.): " permissao

        # Verifica se o usuário e o diretório existem
        if id "$nome_usuario" &>/dev/null && [[ -d "$caminho_dir" ]]; then
            sudo setfacl -m u:"$nome_usuario":"$permissao" "$caminho_dir"
            echo "Permissões $permissao definidas para o usuário $nome_usuario no diretório $caminho_dir."
        else
            echo "Usuário $nome_usuario ou diretório $caminho_dir não existe."
        fi
    done
}

# 10 Função para adicionar permissões de grupo a diretórios
adicionar_perm_grupos() {
    read -p "Quantos grupos você deseja adicionar permissões em diretórios? " num_grupos
    for ((i=1; i<=num_grupos; i++))
    do
        read -p "Digite o nome do grupo $i: " nome_grupo
        read -p "Digite o caminho do diretório: " caminho_dir
        read -p "Digite as permissões (r--, rw-, r-x, rwx, etc.): " permissao

        # Verifica se o grupo e o diretório existem
        if getent group "$nome_grupo" &>/dev/null && [[ -d "$caminho_dir" ]]; then
            sudo setfacl -m g:"$nome_grupo":"$permissao" "$caminho_dir"
            echo "Permissões $permissao definidas para o grupo $nome_grupo no diretório $caminho_dir."
        else
            echo "Grupo $nome_grupo ou diretório $caminho_dir não existe."
        fi
    done
}

# 11 Função para adicionar permissões de "others" a diretórios
adicionar_perm_others() {
    read -p "Quantos diretórios você deseja adicionar permissões para 'others'? " num_diretorios
    for ((i=1; i<=num_diretorios; i++))
    do
        read -p "Digite o caminho do diretório $i: " caminho_dir
        read -p "Digite as permissões para others (r--, rw-, r-x, rwx, =, etc.): " permissao

        # Verifica se o diretório existe
        if [[ -d "$caminho_dir" ]]; then
            sudo chmod o="$permissao" "$caminho_dir"
            echo "Permissões de 'others' definidas para o diretório $caminho_dir."
        else
            echo "Diretório $caminho_dir não existe."
        fi
    done
}

# 12 Função para adicionar grupos a diretórios
adicionar_grupos_a_diretorios() {
    read -p "Quantos grupos você deseja adicionar a diretórios? " num_grupos
    for ((i=1; i<=num_grupos; i++))
    do
        read -p "Digite o nome do grupo $i: " nome_grupo
        read -p "Digite o caminho do diretório: " caminho_dir
        read -p "Digite as permissões para o grupo (r--, rw-, r-x, rwx, etc.): " permissao

        # Verifica se o grupo e o diretório existem
        if getent group "$nome_grupo" &>/dev/null && [[ -d "$caminho_dir" ]]; then
            sudo chgrp "$nome_grupo" "$caminho_dir"
            sudo setfacl -m g:"$nome_grupo":"$permissao" "$caminho_dir"
            echo "Grupo $nome_grupo adicionado ao diretório $caminho_dir com permissões $permissao."
        else
            echo "Grupo $nome_grupo ou diretório $caminho_dir não existe."
        fi
    done
}

# Menu principal
while true
do
    clear
    echo "1. Criar Diretórios"
    echo "2. Deletar Diretórios"
    echo "3. Criar Grupos"
    echo "4. Deletar Grupos"
    echo "5. Criar Usuários"
    echo "6. Deletar Usuários"
    echo "7. Adicionar Usuários a Grupos"
    echo "8. Adicionar Usuários a Diretório como Dono"
    echo "9. Adicionar Permissões de Usuários em Diretórios"
    echo "10. Adicionar Permissões de Grupos em Diretórios"
    echo "11. Adicionar Permissões de 'Others' em Diretórios"
    echo "12. Adicionar Grupos a Diretórios"
    echo "13. Sair"
    read -p "Escolha uma opção: " opcao

    case $opcao in
        1) criar_diretorios ;;
        2) deletar_diretorios ;;
        3) criar_grupos ;;
        4) deletar_grupos ;;
        5) criar_usuarios ;;
        6) deletar_usuarios ;;
        7) adicionar_usuarios_a_grupos ;;
        8) adicionar_usuarios_a_diretorio_como_dono ;;
        9) adicionar_perm_usuarios ;;
        10) adicionar_perm_grupos ;;
        11) adicionar_perm_others ;;
        12) adicionar_grupos_a_diretorios ;;
        13) exit 0 ;;
        *) echo "Opção inválida, tente novamente." ;;
    esac
done
