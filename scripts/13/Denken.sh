echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install mariadb-server -y
service mysql start

echo "
CREATE USER 'kelompokE15'@'%' IDENTIFIED BY 'passwordE15';
CREATE USER 'kelompokE15'@'localhost' IDENTIFIED BY 'passwordE15';
CREATE DATABASE dbkelompokE15;
GRANT ALL PRIVILEGES ON *.* TO 'kelompokE15'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'kelompokE15'@'localhost';
FLUSH PRIVILEGES;
" > init.sql

mysql -u root < init.sql

echo '
# The MariaDB configuration file
#
# The MariaDB/MySQL tools read configuration files in the following order:
# 1. "/etc/mysql/mariadb.cnf" (this file) to set global defaults,
# 2. "/etc/mysql/conf.d/*.cnf" to set global options.
# 3. "/etc/mysql/mariadb.conf.d/*.cnf" to set MariaDB-only options.
# 4. "~/.my.cnf" to set user-specific options.
#
# If the same option is defined multiple times, the last one will apply.
#
# One can use all long options that the program supports.
# Run program with --help to get a list of available options and with
# --print-defaults to see which it would actually understand and use.
#
# This group is read both both by the client and the server
# use it for options that affect everything
#
[client-server]

# Import all .cnf files from configuration directory
!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mariadb.conf.d/

[mysqld]
skip-networking=0
skip-bind-address
' > /etc/mysql/my.cnf
service mysql restart