from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

# Modelo de tarea
class Task(BaseModel):
    instruction: str

# Memoria temporal (luego será DB)
tasks = []

@app.get("/")
def root():
    return {"status": "Backend funcionando"}

@app.post("/task")
def create_task(task: Task):
    task_id = len(tasks)
    new_task = {
        "id": task_id,
        "instruction": task.instruction,
        "status": "pending"
    }
    tasks.append(new_task)
    return new_task

@app.get("/tasks")
def get_tasks():
    return tasks
