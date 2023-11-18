# Berlaku untuk Frieren, Flamme, Fern
echo nameserver 192.168.122.1 > /etc/resolv.conf
rm etc/apt/sources.list.d/php.list

apt-get update
apt-get install mariadb-client -y
apt-get install htop -y
mariadb --host=10.44.2.1 --port=3306 --user=kelompokE15 --password

# 10.44.2.1 -> ip Denken (Database server)