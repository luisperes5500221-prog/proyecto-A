#!/bin/bash

echo "🔍 VERIFICANDO SISTEMA PROYECTO-A..."
echo "======================================"

# =========================
# 🧩 1. PYTHON + VENV
# =========================
echo ""
echo "🐍 Python:"
python3 --version

echo "📦 Venv:"
if [ -d "venv" ]; then
    echo "✅ venv existe"
else
    echo "❌ venv NO existe"
fi

# =========================
# 🧩 2. DEPENDENCIAS PYTHON
# =========================
echo ""
echo "📚 Librerías clave:"

for pkg in fastapi uvicorn redis sqlalchemy psycopg2 playwright browserforge; do
    pip show $pkg >/dev/null 2>&1 && echo "✅ $pkg" || echo "❌ $pkg"
done

# =========================
# 🧩 3. PLAYWRIGHT
# =========================
echo ""
echo "🌐 Playwright:"
playwright --version 2>/dev/null && echo "✅ playwright instalado" || echo "❌ playwright no detectado"

# =========================
# 🧩 4. REDIS
# =========================
echo ""
echo "🔴 Redis:"
if systemctl is-active --quiet redis; then
    echo "✅ Redis activo"
    redis-cli ping
else
    echo "❌ Redis NO activo"
fi

# =========================
# 🧩 5. POSTGRES
# =========================
echo ""
echo "🐘 PostgreSQL:"
if systemctl is-active --quiet postgresql; then
    echo "✅ PostgreSQL activo"
else
    echo "❌ PostgreSQL NO activo"
fi

# =========================
# 🧩 6. DOCKER
# =========================
echo ""
echo "🐳 Docker:"
if systemctl is-active --quiet docker; then
    echo "✅ Docker activo"
    docker --version
else
    echo "❌ Docker NO activo"
fi

# =========================
# 🧩 7. FIRECRACKER
# =========================
echo ""
echo "🔥 Firecracker:"
if [ -f "$HOME/firecracker/release-v1.15.0-x86_64/firecracker" ]; then
    echo "✅ Firecracker presente"
else
    echo "❌ Firecracker no encontrado"
fi

# =========================
# 🧩 8. ESTRUCTURA PROYECTO
# =========================
echo ""
echo "📁 Estructura:"

for dir in backend workers scripts logs data external; do
    [ -d "$dir" ] && echo "✅ $dir" || echo "❌ $dir"
done

# =========================
# 🧩 9. SCRIPTS
# =========================
echo ""
echo "⚙️ Scripts:"

for file in run_backend.sh run_worker.sh run_worker_pro.sh; do
    [ -f "$file" ] && echo "✅ $file" || echo "❌ $file"
done

# =========================
# 🧩 10. GIT
# =========================
echo ""
echo "📤 Git:"
git status

echo ""
echo "======================================"
echo "✅ VERIFICACIÓN TERMINADA"
