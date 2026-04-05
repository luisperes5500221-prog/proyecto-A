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
