#!/bin/bash

echo "🔍 Verificando sistema..."

# ---------------- BASE ----------------
sudo apt update -y

# ---------------- PYTHON ----------------
sudo apt install -y python3-pip python3-venv

# ---------------- REDIS ----------------
sudo apt install -y redis-server
sudo systemctl start redis

# ---------------- POSTGRES ----------------
sudo apt install -y postgresql
sudo systemctl start postgresql

# ---------------- DOCKER ----------------
sudo apt install -y docker.io
sudo systemctl start docker

# ---------------- KVM ----------------
sudo apt install -y qemu-kvm libvirt-daemon-system

# ---------------- NODE ----------------
sudo apt install -y nodejs npm

# ---------------- PYTHON LIBS ----------------
source ~/proyecto-A/venv/bin/activate

pip install --upgrade pip
pip install fastapi uvicorn redis requests psycopg2-binary selenium playwright python-dotenv

# ---------------- PLAYWRIGHT FIX ----------------
export PATH=$PATH:/home/aoi/.local/bin
playwright install

echo "✅ SISTEMA LISTO"
