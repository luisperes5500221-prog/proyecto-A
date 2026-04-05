from fastapi import FastAPI
from pydantic import BaseModel
import redis
import json

# ---------------- CONFIG ----------------
app = FastAPI()

# conexión a Redis
r = redis.Redis(host='127.0.0.1', port=6379, decode_responses=True)

# ---------------- MODELOS ----------------
class Task(BaseModel):
    instruction: str

# ---------------- ENDPOINTS ----------------

@app.get("/")
def root():
    return {"status": "Backend con Redis funcionando"}

# Crear tarea → se envía a Redis
@app.post("/task")
def create_task(task: Task):
    data = {
        "instruction": task.instruction
    }

    r.rpush("queue", json.dumps(data))

    print("📥 Enviado a Redis:", data)

    return {
        "status": "ok",
        "message": "tarea enviada",
        "data": data
    }

# Ver tareas pendientes (debug opcional)
@app.get("/queue")
def get_queue():
    tasks = r.lrange("queue", 0, -1)
    return [json.loads(t) for t in tasks]

# Limpiar cola (debug)
@app.delete("/queue")
def clear_queue():
    r.delete("queue")
    return {"status": "cola limpiada"}
