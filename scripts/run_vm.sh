#!/bin/bash

echo "🔥 Iniciando micro-VM (simulada)"

FC=~/firecracker/release-v1.15.0-x86_64/firecracker

if [ ! -f "$FC" ]; then
  echo "❌ Firecracker no encontrado"
  exit 1
fi

echo "⚠️ Aquí iría config JSON real (kernel + rootfs)"
echo "👉 Por ahora es placeholder funcional"
