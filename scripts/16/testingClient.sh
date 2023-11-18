ab -n 100 -c 10 -p data.json -T application/json http://10.44.4.1/api/auth/login
curl -X POST -H "Content-Type: application/json" -d '{"username": "kelompokE15","password": "passwordE15"}' http://10.44.4.1/api/auth/login
