echo nameserver 10.44.1.2 > /etc/resolv.conf
apt-get update
apt-get install apache2-utils -y
apt-get install lynx -y
echo ' 
{
    "username": "kelompokE15",
    "password": "passwordE15"
}
' > data.json 

ab -n 100 -c 10 -p data.json -T application/json http://10.44.4.1/api/auth/register
curl -X POST -H "Content-Type: application/json" -d '{"username": "kelompokE15","password": "passwordE15"}' http://10.44.4.1/api/auth/register