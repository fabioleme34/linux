#!/bin/bash

# Pergunta se deseja enviar as atualizações para o GitHub
read -p "Você quer enviar as atualizações para o GitHub? (sim/não): " resposta

if [[ "$resposta" == "sim" || "$resposta" == "sim" ]]; then
  # Caminho do repositório local
  repo_dir="/caminho/do/seu/repositorio"
  cd "$repo_dir"

  # Adiciona as alterações, faz o commit e envia para o GitHub
  git add .
  git commit -m "Atualizando repositório"
  git push origin main
  echo "Atualizações enviadas com sucesso!"
else
  echo "Atualizações não enviadas."
fi
