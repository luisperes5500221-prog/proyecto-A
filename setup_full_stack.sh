#!/bin/bash

echo "🚀 SETUP FULL STACK PROYECTO-A"

cd ~/proyecto-A
source venv/bin/activate

# ---------------- DEPENDENCIAS PYTHON ----------------
echo "📦 Instalando libs..."
pip install docker redis subprocess32 playwright selenium

# ---------------- DOCKER WORKER ----------------
echo "🐳 Configurando Docker worker..."

mkdir -p docker_worker
cat > docker_worker/Dockerfile << 'EOF'
FROM python:3.10-slim

WORKDIR /app

RUN pip install redis requests

COPY worker.py .

CMD ["python", "worker.py"]
EOF

cat > docker_worker/worker.py << 'EOF'
import redis
import json
import subprocess

r = redis.Redis(host='host.docker.internal', port=6379, decode_responses=True)

print("🐳 Docker Worker iniciado")

while True:
    task = r.blpop("queue", timeout=5)

    if task:
        data = json.loads(task[1])
        cmd = data.get("instruction")

        print(f"🔥 Ejecutando comando: {cmd}")

        try:
            result = subprocess.check_output(cmd, shell=True, stderr=subprocess.STDOUT)
            print(result.decode())
        except Exception as e:
            print(f"❌ Error: {e}")
EOF

# ---------------- BUILD DOCKER ----------------
echo "🔨 Construyendo Docker image..."
cd docker_worker
docker build -t proyectoA_worker .
cd ..

# ---------------- SCRIPT PARA LANZAR WORKERS ----------------
cat > run_docker_workers.sh << 'EOF'
#!/bin/bash

echo "🚀 Lanzando 3 workers..."

for i in {1..3}
do
docker run -d --name worker_$i proyectoA_worker
done
EOF

chmod +x run_docker_workers.sh

# ---------------- FIRECRACKER SCRIPT ----------------
echo "🧠 Configurando Firecracker..."

mkdir -p scripts

cat > scripts/run_vm.sh << 'EOF'
#!/bin/bash

echo "🔥 Iniciando micro-VM (simulada)"

FC=~/firecracker/release-v1.15.0-x86_64/firecracker

if [ ! -f "$FC" ]; then
  echo "❌ Firecracker no encontrado"
  exit 1
fi

echo "⚠️ Aquí iría config JSON real (kernel + rootfs)"
echo "👉 Por ahora es placeholder funcional"
EOF

chmod +x scripts/run_vm.sh

# ---------------- AUTOMATIZACIÓN ----------------
echo "🤖 Configurando automatización..."

mkdir -p automation

cat > automation/browser.py << 'EOF'
from playwright.sync_api import sync_playwright

def run():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        page.goto("https://example.com")
        print("Título:", page.title())
        browser.close()

if __name__ == "__main__":
    run()
EOF

# ---------------- WORKER LOCAL MEJORADO ----------------
cat > workers/worker.py << 'EOF'
import redis
import json
import subprocess

r = redis.Redis(host='localhost', port=6379, decode_responses=True)

print("⚡ Worker avanzado iniciado")

while True:
    task = r.blpop("queue", timeout=5)

    if task:
        data = json.loads(task[1])
        cmd = data.get("instruction")

        print(f"🔥 Ejecutando: {cmd}")

        try:
            result = subprocess.check_output(cmd, shell=True, stderr=subprocess.STDOUT)
            print(result.decode())
        except Exception as e:
            print(f"❌ Error: {e}")
EOF

# ---------------- SCRIPT DE PRUEBA ----------------
cat > test_commands.sh << 'EOF'
#!/bin/bash

curl -X POST http://127.0.0.1:5000/task \
-H "Content-Type: application/json" \
-d '{"instruction":"ls"}'

curl -X POST http://127.0.0.1:5000/task \
-H "Content-Type: application/json" \
-d '{"instruction":"whoami"}'

curl -X POST http://127.0.0.1:5000/task \
-H "Content-Type: application/json" \
-d '{"instruction":"uname -a"}'
EOF

chmod +x test_commands.sh

echo "✅ FULL STACK CONFIGURADO"
