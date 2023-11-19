echo '
upstream backend  {
        ip_hash;
        server 10.44.3.1; #IP Lawine
        server 10.44.3.2; #IP Linie
        server 10.44.3.3; #IP Lugner
}

server {
listen 80;
server_name granz.channel.E15.com;

        location / {
                proxy_pass http://backend;
                proxy_set_header    X-Real-IP $remote_addr;
                proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header    Host $http_host;
        }

error_log /var/log/nginx/lb_error.log;
access_log /var/log/nginx/lb_access.log;

}
' > /etc/nginx/sites-available/lb-eisen

service nginx restart

#ab -n 200 -c 10 http://10.44.2.2/