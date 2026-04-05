#!/bin/bash

echo "🚀 Lanzando 3 workers..."

for i in {1..3}
do
docker run -d --name worker_$i proyectoA_worker
done
