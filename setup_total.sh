#!/bin/bash

echo "🚀 INICIANDO INSTALACIÓN TOTAL PROYECTO-A"

# -------------------------------
# 🧩 1. ACTUALIZAR SISTEMA
# -------------------------------
sudo apt update && sudo apt upgrade -y

# -------------------------------
# 🧩 2. INSTALAR BASE
# -------------------------------
sudo apt install -y \
python3 python3-pip python3-venv \
git curl wget unzip \
build-essential \
redis-server \
postgresql postgresql-contrib \
docker.io docker-compose \
nodejs npm

# -------------------------------
# 🧩 3. ACTIVAR SERVICIOS
# -------------------------------
sudo systemctl enable redis
sudo systemctl start redis

sudo systemctl enable postgresql
sudo systemctl start postgresql

sudo systemctl enable docker
sudo systemctl start docker

# -------------------------------
# 🧩 4. PERMISOS DOCKER
# -------------------------------
sudo usermod -aG docker $USER

# -------------------------------
# 🧩 5. FIRECRACKER
# -------------------------------
mkdir -p ~/firecracker
cd ~/firecracker

if [ ! -f firecracker-v1.15.0-x86_64.tgz ]; then
    wget https://github.com/firecracker-microvm/firecracker/releases/download/v1.15.0/firecracker-v1.15.0-x86_64.tgz
    tar -xvf firecracker-v1.15.0-x86_64.tgz
fi

cd ~

# -------------------------------
# 🧩 6. PROYECTO
# -------------------------------
cd ~/proyecto-A

# crear venv si no existe
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

source venv/bin/activate

# -------------------------------
# 🧩 7. DEPENDENCIAS PYTHON
# -------------------------------
pip install --upgrade pip

pip install \
fastapi uvicorn \
redis psycopg2-binary \
sqlalchemy \
requests \
faker \
python-dotenv \
playwright \
httpx \
aiofiles

# -------------------------------
# 🧩 8. PLAYWRIGHT
# -------------------------------
playwright install
playwright install-deps

# -------------------------------
# 🧩 9. ESTRUCTURA PROYECTO
# -------------------------------
mkdir -p backend workers scripts logs data external

# -------------------------------
# 🧩 10. DOCKER TEST
# -------------------------------
sudo docker run hello-world || true

# -------------------------------
# 🧩 11. REDIS TEST
# -------------------------------
redis-cli ping

# -------------------------------
# 🧩 12. POSTGRES TEST
# -------------------------------
sudo -u postgres psql -c "\l" || true

# -------------------------------
# 🧩 13. GUARDAR DEPENDENCIAS
# -------------------------------
pip freeze > requirements.txt

# -------------------------------
# 🧩 14. GIT UPDATE
# -------------------------------
git add .

git commit -m "🔥 setup completo sistema distribuido + automatizacion + identidad" || true

git push origin main

# -------------------------------
# 🧩 15. FINAL
# -------------------------------
echo ""
echo "✅ SISTEMA TOTAL INSTALADO"
echo "⚠️ IMPORTANTE: reinicia sesión para docker (newgrp docker)"
echo ""

