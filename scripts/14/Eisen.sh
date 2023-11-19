# No 14
echo '
upstream laravel {
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
}
' > /etc/nginx/sites-available/lb-laravel


ln -s /etc/nginx/sites-available/lb-laravel /etc/nginx/sites-enabled
service nginx restart