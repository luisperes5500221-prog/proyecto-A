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
