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
