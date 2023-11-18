echo '
upstream laravel {
        least_conn;
        server 10.44.4.1;
        server 10.44.4.2;
        server 10.44.4.3;
}

server {
        listen 88;
        server_name riegel.canyon.E15.com www.riegel.canyon.E15.com;

        location / {
                proxy_pass http://laravel;
        }

        location /frieren/ {
                proxy_bind 10.44.2.2;
                proxy_pass http://10.44.4.1/;
        }

        location /flamme/ {
                proxy_bind 10.44.2.2;
                proxy_pass http://10.44.4.2/;
        }

        location /fern/ {
                proxy_bind 10.44.2.2;
                proxy_pass http://10.44.4.3/;
        }


}

' > /etc/nginx/sites-available/lb-laravel


ln -s /etc/nginx/sites-available/lb-laravel /etc/nginx/sites-enabled
service nginx restart
