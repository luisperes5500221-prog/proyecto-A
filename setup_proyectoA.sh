#!/bin/bash

echo "🚀 Iniciando setup de proyecto-A..."

# =========================
# 🔄 UPDATE SISTEMA
# =========================
sudo apt update && sudo apt upgrade -y

# =========================
# 🧱 DEPENDENCIAS BASE
# =========================
sudo apt install -y \
    git curl wget unzip nano \
    python3 python3-pip python3-venv \
    nodejs npm \
    build-essential

# =========================
# 🐍 ENTORNO PYTHON
# =========================
cd ~/proyecto-A

python3 -m venv venv
source venv/bin/activate

pip install --upgrade pip

# =========================
# 📦 LIBRERÍAS PYTHON
# =========================
pip install \
    fastapi uvicorn requests \
    selenium undetected-chromedriver \
    qreader pyzbar pillow opencv-python \
    numpy pandas

# =========================
# 🌐 NODE (para OTP API)
# =========================
sudo npm install -g npm@latest

# =========================
# 🔐 CLONAR FREE-OTP-API
# =========================
cd ~/proyecto-A
mkdir -p external
cd external

if [ ! -d "free-otp-api" ]; then
    git clone https://github.com/Shelex/free-otp-api.git
fi

cd free-otp-api
npm install

# =========================
# 🧠 VOLVER AL PROYECTO
# =========================
cd ~/proyecto-A

# =========================
# 🔄 ACTUALIZAR REPO
# =========================
git add .
git commit -m "setup automatico inicial $(date)" || true
git push

# =========================
# 📁 ESTRUCTURA BASE
# =========================
mkdir -p backend workers scripts logs data

# =========================
# ⚙️ ARCHIVO ENV
# =========================
cat <<EOL > .env
BACKEND_URL=http://127.0.0.1:5000
EOL

# =========================
# 🧪 SCRIPT RUN BACKEND
# =========================
cat <<EOL > run_backend.sh
#!/bin/bash
source venv/bin/activate
uvicorn backend.main:app --host 0.0.0.0 --port 5000
EOL

chmod +x run_backend.sh

# =========================
# 🧪 SCRIPT RUN WORKER
# =========================
cat <<EOL > run_worker.sh
#!/bin/bash
source venv/bin/activate
python workers/worker.py
EOL

chmod +x run_worker.sh

echo "✅ Setup COMPLETADO"
echo "👉 Ejecuta backend: ./run_backend.sh"
echo "👉 Ejecuta worker: ./run_worker.sh"
