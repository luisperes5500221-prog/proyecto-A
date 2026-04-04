import requests
import time

BACKEND_URL = "http://127.0.0.1:5000"

def get_tasks():
    try:
        response = requests.get(f"{BACKEND_URL}/tasks")
        return response.json()
    except:
        return []

def process_task(task):
    print(f"Ejecutando tarea {task['id']}: {task['instruction']}")
    time.sleep(2)  # simulación

while True:
    tasks = get_tasks()

    for task in tasks:
        if task["status"] == "pending":
            process_task(task)
            task["status"] = "done"

    time.sleep(5)
