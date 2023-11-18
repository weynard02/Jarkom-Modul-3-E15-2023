# Berlaku untuk Frieren, Flamme, Fern

# Default
echo '
[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.
pm = dynamic

pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
' > /etc/php/8.0/fpm/pool.d/www.conf

service php8.0-fpm start
service php8.0-fpm restart
service nginx restart

# naik 1
echo '
[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.
pm = dynamic

pm.max_children = 20
pm.start_servers = 5
pm.min_spare_servers = 2
pm.max_spare_servers = 6
' > /etc/php/8.0/fpm/pool.d/www.conf
/etc/init.d/php8.0-fpm restart
service nginx restart

# naik 2
echo '
[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.
pm = dynamic

pm.max_children = 50
pm.start_servers = 10
pm.min_spare_servers = 5
pm.max_spare_servers = 15
' > /etc/php/8.0/fpm/pool.d/www.conf
/etc/init.d/php8.0-fpm restart
service nginx restart

# naik 3
echo '
[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.
pm = dynamic

pm.max_children = 100
pm.start_servers = 15
pm.min_spare_servers = 10
pm.max_spare_servers = 20
' > /etc/php/8.0/fpm/pool.d/www.conf
/etc/init.d/php8.0-fpm restart
service nginx restart