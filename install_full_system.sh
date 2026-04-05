#!/bin/bash

echo "🚀 INSTALANDO SISTEMA COMPLETO PROYECTO-A"

# ---------------- SISTEMA BASE ----------------
sudo apt update -y
sudo apt upgrade -y

sudo apt install -y \
python3 python3-pip python3-venv \
git curl wget unzip build-essential \
net-tools htop tmux

# ---------------- REDIS ----------------
sudo apt install -y redis-server
sudo systemctl enable redis
sudo systemctl start redis

# ---------------- POSTGRESQL ----------------
sudo apt install -y postgresql postgresql-contrib
sudo systemctl enable postgresql
sudo systemctl start postgresql

# ---------------- DOCKER ----------------
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# ---------------- KVM / VIRTUALIZACIÓN ----------------
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

# ---------------- FIRECRACKER ----------------
mkdir -p ~/firecracker
cd ~/firecracker

wget https://github.com/firecracker-microvm/firecracker/releases/latest/download/firecracker-v1.7.0-x86_64.tgz
tar -xvf firecracker-v1.7.0-x86_64.tgz

# ---------------- NODE (para herramientas) ----------------
sudo apt install -y nodejs npm

# ---------------- AUTOMATIZACIÓN ----------------
pip install --upgrade pip
pip install \
fastapi uvicorn requests redis psycopg2-binary \
selenium playwright python-dotenv

playwright install

# ---------------- CLONAR HERRAMIENTAS ----------------

cd ~
mkdir -p tools
cd tools

# Gmail creator
git clone https://github.com/ShadowHackrs/gmail-account-creator.git

# OTP API
git clone https://github.com/Shelex/free-otp-api.git

# ---------------- FINAL ----------------
echo "✅ INSTALACIÓN COMPLETA"
echo "⚠️ Reinicia sesión para Docker (newgrp docker)"
