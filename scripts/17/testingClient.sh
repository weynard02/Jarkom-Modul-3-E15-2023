curl -X POST -H "Content-Type: application/json" -d '{"username": "kelompokE15","password": "passwordE15"}' http://10.44.4.1/api/auth/login | jq -r '.token' > login.txt

token=$(cat login.txt) | curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $token" http://10.44.4.1/api/me

token=$(cat login.txt) | ab -n 100 -c 10 -H "Authorization: Bearer $token"  10.44.4.1/api/me