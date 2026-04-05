#!/bin/bash

echo "🚀 ACTUALIZANDO A STACK PRO..."

cd ~/proyecto-A

# ================================
# 🧩 1. ACTIVAR ENTORNO
# ================================
source venv/bin/activate

# ================================
# 🧩 2. LIMPIAR DEPENDENCIAS OBSOLETAS
# ================================
echo "🧹 Eliminando dependencias viejas..."

pip uninstall -y \
puppeteer pyppeteer \
selenium \
undetected-chromedriver \
playwright-stealth || true

npm uninstall -g puppeteer puppeteer-extra puppeteer-extra-plugin-stealth || true

# ================================
# 🧩 3. INSTALAR STACK PRO
# ================================
echo "📦 Instalando nuevas dependencias PRO..."

pip install --upgrade pip

pip install \
playwright \
browserforge \
faker \
httpx \
aiofiles \
redis \
psycopg2-binary \
sqlalchemy \
python-dotenv

# instalar playwright browsers
playwright install

# ================================
# 🧩 4. CREAR ESTRUCTURA PRO
# ================================
echo "📁 Creando estructura avanzada..."

mkdir -p \
workers/pro \
workers/utils \
workers/fingerprint \
workers/behavior \
workers/proxies \
accounts \
sessions \
fingerprints

# ================================
# 🧩 5. ARCHIVO BASE WORKER PRO
# ================================
echo "🧠 Creando worker PRO base..."

cat > workers/pro/worker_pro.py << 'EOF'
import redis
import json
import time

r = redis.Redis(host='localhost', port=6379, db=0)

print("⚡ Worker PRO iniciado")

while True:
    task = r.blpop("queue", timeout=5)

    if task:
        _, data = task
        data = json.loads(data)

        instruction = data.get("instruction")

        print(f"🔥 Ejecutando tarea PRO: {instruction}")

        # Aquí irá Playwright + fingerprint + proxy
        time.sleep(2)
EOF

# ================================
# 🧩 6. SCRIPT RUN PRO
# ================================
cat > run_worker_pro.sh << 'EOF'
#!/bin/bash
source venv/bin/activate
python workers/pro/worker_pro.py
EOF

chmod +x run_worker_pro.sh

# ================================
# 🧩 7. ACTUALIZAR REQUIREMENTS
# ================================
pip freeze > requirements.txt

# ================================
# 🧩 8. GIT UPDATE
# ================================
echo "📤 Subiendo cambios a GitHub..."

git add .

git commit -m "🔥 upgrade to PRO stack: antifingerprint + modern automation" || true

git push origin main

# ================================
# 🧩 9. FINAL
# ================================
echo ""
echo "✅ STACK PRO INSTALADO"
echo "👉 Usa: ./run_worker_pro.sh"
echo ""
