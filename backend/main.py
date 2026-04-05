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
