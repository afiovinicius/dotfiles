#!/bin/bash

set -e

echo "=== 🔧 LIMPEZA DE SISTEMA ARCHLINUX ==="

echo -e "\n1️⃣  Limpando o Docker (containers, imagens, volumes e redes não utilizados)..."
docker system prune -a --volumes -f

echo -e "\n2️⃣  Limpando cache de pacotes antigos do pacman (mantendo a versão mais recente)..."
sudo paccache -rk1

echo -e "\n3️⃣  Removendo pacotes órfãos não mais requeridos..."
sudo pacman -Rns $(pacman -Qdtq) 2>/dev/null || echo "Nenhum pacote órfão encontrado."

echo -e "\n4️⃣  Limpando logs do systemd journal (mantendo apenas 3 dias)..."
sudo journalctl --vacuum-time=3d

echo -e "\n5️⃣  Limpando caches de ferramentas de linha de comando..."

if command -v npm &> /dev/null; then
    echo "→ npm"
    npm cache clean --force
fi

if command -v pip &> /dev/null; then
    echo "→ pip"
    pip cache purge
fi

if command -v cargo &> /dev/null; then
    echo "→ cargo"
    cargo cache -a
fi

echo -e "\n6️⃣  Diagnóstico: Maiores diretórios no sistema (top 10)..."
sudo du -sh /* 2>/dev/null | sort -hr | head -10

echo -e "\n✅ Limpeza concluída com sucesso!"
