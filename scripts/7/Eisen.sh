echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update && apt-get install apache2-utils -y
apt-get install nginx php php-fpm -y
apt-get install htop -y
apt-get install lynx -y

echo '
upstream backend  {
        server 10.44.3.1 weight=640; #IP Lawine
        server 10.44.3.2 weight=200; #IP Linie
        server 10.44.3.3 weight=25; #IP Lugner
}

server {
        listen 80;
        7server_name granz.channel.E15.com www.granz.channel.E15.com;

        location / {
                proxy_pass http://backend;
                proxy_set_header    X-Real-IP $remote_addr;
                proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header    Host $http_host;

        }
        error_log /var/log/nginx/lb_error.log;
        access_log /var/log/nginx/lb_access.log;

}' > /etc/nginx/sites-available/lb-eisen
ln -s /etc/nginx/sites-available/lb-eisen /etc/nginx/sites-enabled
service nginx restart

#Testing
ab -V

echo nameserver 10.44.1.2 > /etc/resolv.conf
mkdir /root/benchmark
cd /root/benchmark
ab -n 1000 -c 100 -g out.data http://10.44.2.2/
cd /
# cat /root/benchmark/out.data
