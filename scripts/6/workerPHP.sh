# Berlaku untuk Lawine, Linie, Lugner

echo nameserver 192.168.122.1 > /etc/resolv.conf

apt-get update && apt-get install nginx -y
service nginx restart

apt-get install lynx -y

apt-get install php php-fpm -y
service php7.3-fpm start
service php7.3-fpm status

apt-get install wget unzip -y

wget https://github.com/weynard02/jarkom-modul3-resources/archive/refs/heads/main.zip

unzip main.zip

touch /etc/nginx/sites-available/granz

echo '
server {

        listen 80;

        root /var/www/granz;

        index index.php index.html index.htm;
        server_name _;

        location / {
                        try_files $uri $uri/ /index.php?$query_string;
        }

        # pass PHP scripts to FastCGI server
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
        }
        location ~ /\.ht {
                        deny all;
        }

        error_log /var/log/nginx/granz_error.log;
        access_log /var/log/nginx/granz_access.log;
 } ' > /etc/nginx/sites-available/granz

ln -s /etc/nginx/sites-available/granz /etc/nginx/sites-enabled

mkdir var/www/granz

mv jarkom-modul3-resources-main/granz.channel.E15.com/modul-3/* var/www/granz/

rm -rf /etc/nginx/sites-enabled/default
service php7.3-fpm start
service nginx restart
apt-get install htop -y

echo nameserver 10.44.1.2 > /etc/resolv.conf
