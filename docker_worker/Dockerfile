FROM python:3.10-slim

WORKDIR /app

RUN pip install redis requests

COPY worker.py .

CMD ["python", "worker.py"]
