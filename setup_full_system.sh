#!/bin/bash

echo "🚀 INICIANDO SETUP TOTAL PROYECTO-A"

# ================================
# 🧩 1. ACTUALIZAR SISTEMA
# ================================
sudo apt update && sudo apt upgrade -y

# ================================
# 🧩 2. INSTALAR BASE
# ================================
sudo apt install -y \
python3 python3-pip python3-venv \
git curl wget unzip \
build-essential \
redis-server \
postgresql postgresql-contrib \
docker.io docker-compose \
nodejs npm \
proxychains \
net-tools \
ffmpeg

# ================================
# 🧩 3. ACTIVAR SERVICIOS
# ================================
sudo systemctl enable redis
sudo systemctl restart redis

sudo systemctl enable postgresql
sudo systemctl restart postgresql

sudo systemctl enable docker
sudo systemctl restart docker

# ================================
# 🧩 4. PERMISOS DOCKER
# ================================
sudo usermod -aG docker $USER

# ================================
# 🧩 5. FIRECRACKER
# ================================
mkdir -p ~/firecracker
cd ~/firecracker

if [ ! -f firecracker-v1.15.0-x86_64.tgz ]; then
    wget https://github.com/firecracker-microvm/firecracker/releases/download/v1.15.0/firecracker-v1.15.0-x86_64.tgz
    tar -xvf firecracker-v1.15.0-x86_64.tgz
fi

cd ~

# ================================
# 🧩 6. PROYECTO
# ================================
cd ~/proyecto-A

# crear venv si no existe
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

source venv/bin/activate

# ================================
# 🧩 7. DEPENDENCIAS PYTHON
# ================================
pip install --upgrade pip

pip install \
fastapi uvicorn \
redis psycopg2-binary sqlalchemy \
requests httpx aiofiles \
faker python-dotenv \
playwright \
selenium \
undetected-chromedriver \
beautifulsoup4 lxml \
pandas \
openai

# ================================
# 🧩 8. PLAYWRIGHT
# ================================
playwright install
playwright install-deps

# ================================
# 🧩 9. NODE TOOLS (AUTOMATION EXTRA)
# ================================
npm install -g \
puppeteer \
puppeteer-extra \
puppeteer-extra-plugin-stealth

# ================================
# 🧩 10. ESTRUCTURA PROYECTO
# ================================
mkdir -p backend workers scripts logs data external accounts proxies

# ================================
# 🧩 11. BASE DE DATOS
# ================================
sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname = 'proyectoA_db'" | grep -q 1 || \
sudo -u postgres createdb proyectoA_db

# ================================
# 🧩 12. REDIS TEST
# ================================
echo "🔍 Redis test:"
redis-cli ping

# ================================
# 🧩 13. DOCKER TEST
# ================================
echo "🔍 Docker test:"
sudo docker run hello-world || true

# ================================
# 🧩 14. GUARDAR DEPENDENCIAS
# ================================
pip freeze > requirements.txt

# ================================
# 🧩 15. GIT UPDATE
# ================================
git add .

git commit -m "🔥 full system setup: backend + workers + automation + identity + infra" || true

git push origin main

# ================================
# 🧩 16. FINAL
# ================================
echo ""
echo "✅ SISTEMA COMPLETO INSTALADO"
echo "⚠️ Ejecuta: newgrp docker (o reinicia sesión)"
echo ""
