#!/bin/bash

echo "🔥 RESET TOTAL A STACK PRO..."

# =========================
# 1. LIMPIEZA
# =========================
echo "🧹 Eliminando dependencias viejas..."

source venv/bin/activate

pip uninstall -y selenium undetected-chromedriver pyppeteer puppeteer playwright-stealth 2>/dev/null

rm -rf workers/old
rm -rf workers/legacy
rm -rf scripts/old

# =========================
# 2. INSTALAR STACK PRO
# =========================
echo "📦 Instalando stack PRO..."

pip install --upgrade pip

pip install \
fastapi \
uvicorn \
redis \
sqlalchemy \
psycopg2-binary \
httpx \
aiofiles \
python-dotenv \
faker \
playwright \
browserforge

echo "🌐 Instalando navegadores..."
playwright install --with-deps

# =========================
# 3. FIRECRACKER
# =========================
echo "🔥 Instalando Firecracker..."

mkdir -p ~/firecracker
cd ~/firecracker

if [ ! -f firecracker ]; then
    curl -LO https://github.com/firecracker-microvm/firecracker/releases/latest/download/firecracker-v1.5.0-x86_64.tgz
    tar -xvf firecracker-v1.5.0-x86_64.tgz
    chmod +x release-v*/firecracker
    sudo cp release-v*/firecracker /usr/local/bin/firecracker
fi

cd ~/proyecto-A

# =========================
# 4. DOCKER
# =========================
echo "🐳 Verificando Docker..."

sudo systemctl start docker
sudo usermod -aG docker $USER

# =========================
# 5. WORKER PRO
# =========================
echo "🧠 Creando worker PRO..."

mkdir -p workers/pro

cat << 'EOF' > workers/pro/worker_pro.py
import redis
import time
import subprocess
import json

r = redis.Redis(host='localhost', port=6379, decode_responses=True)

print("⚡ Worker PRO listo...")

while True:
    task = r.blpop("queue", timeout=5)

    if task:
        data = json.loads(task[1])
        instruction = data.get("instruction")

        print(f"🚀 Ejecutando: {instruction}")

        try:
            result = subprocess.getoutput(instruction)
            print("📤 Resultado:")
            print(result)
        except Exception as e:
            print("❌ Error:", e)

    else:
        print("⏳ Esperando tareas...")
        time.sleep(2)
EOF

# =========================
# 6. SCRIPT RUN PRO
# =========================
cat << 'EOF' > run_worker_pro.sh
#!/bin/bash
source venv/bin/activate
python3 workers/pro/worker_pro.py
EOF

chmod +x run_worker_pro.sh

# =========================
# 7. BACKEND (REDIS)
# =========================
echo "🧠 Actualizando backend para Redis..."

cat << 'EOF' > backend/main.py
from fastapi import FastAPI
import redis
import json

app = FastAPI()

r = redis.Redis(host='localhost', port=6379, decode_responses=True)

@app.get("/")
def root():
    return {"status": "Backend PRO funcionando"}

@app.post("/task")
def create_task(data: dict):
    r.rpush("queue", json.dumps(data))
    print("📥 Enviado a Redis:", data)
    return {"status": "ok", "data": data}
EOF

# =========================
# 8. REDIS / POSTGRES / DOCKER
# =========================
echo "🔧 Reiniciando servicios..."

sudo systemctl restart redis
sudo systemctl restart postgresql
sudo systemctl restart docker

# =========================
# 9. GIT
# =========================
echo "📤 Subiendo cambios..."

git add .
git commit -m "🔥 reset completo a stack PRO limpio"
git push

echo ""
echo "✅ SISTEMA PRO TOTAL LISTO"
echo "👉 Ejecuta:"
echo "   ./run_backend.sh"
echo "   ./run_worker_pro.sh"
echo ""
