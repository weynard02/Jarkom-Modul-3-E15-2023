#No. 10
mkdir /etc/nginx/rahasisakita
touch /etc/nginx/rahasisakita/.htpasswd
htpasswd -b -c /etc/nginx/rahasisakita/.htpasswd netics ajkE15
echo '
upstream backend  {
        server 10.44.3.1 weight=640; #IP Lawine
        server 10.44.3.2 weight=200; #IP Linie
        server 10.44.3.3 weight=25; #IP Lugner
}

server {
        listen 80;
        server_name granz.channel.E15.com www.granz.channel.E15.com;

        location / {
                proxy_pass http://backend;
                proxy_set_header    X-Real-IP $remote_addr;
                proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header    Host $http_host;

                auth_basic "Administrators Area";
                auth_basic_user_file /etc/nginx/rahasisakita/.htpasswd;

                allow 10.44.3.69;
                allow 10.44.3.70;
                allow 10.44.4.167;
                allow 10.44.4.168;
                deny all;
        }

        location /its {
                proxy_pass https://www.its.ac.id;
        }

        location ~ /\.ht {
            deny all;
        }

        error_log /var/log/nginx/lb_error.log;
        access_log /var/log/nginx/lb_access.log;

}' > /etc/nginx/sites-available/lb-eisen


service nginx restart