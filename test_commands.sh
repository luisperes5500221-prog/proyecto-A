#!/bin/bash

curl -X POST http://127.0.0.1:5000/task \
-H "Content-Type: application/json" \
-d '{"instruction":"ls"}'

curl -X POST http://127.0.0.1:5000/task \
-H "Content-Type: application/json" \
-d '{"instruction":"whoami"}'

curl -X POST http://127.0.0.1:5000/task \
-H "Content-Type: application/json" \
-d '{"instruction":"uname -a"}'
