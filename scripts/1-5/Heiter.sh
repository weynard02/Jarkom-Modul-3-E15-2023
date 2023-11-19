echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install bind9 -y

echo '
zone "riegel.canyon.E15.com" {
        type master;
        file "/etc/bind/riegel/riegel.canyon.E15.com";
};

zone "granz.channel.E15.com" {
        type master;
        file "/etc/bind/granz/granz.channel.E15.com";
};
' > /etc/bind/named.conf.local

mkdir /etc/bind/riegel/

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     riegel.canyon.E15.com. root.riegel.canyon.E15.com. (
                     2023111301         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      riegel.canyon.E15.com.
@       IN      A       10.44.4.1 ; IP Frieren
www     IN      CNAME   riegel.canyon.E15.com.
' > /etc/bind/riegel/riegel.canyon.E15.com

mkdir /etc/bind/granz/

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     granz.channel.E15.com. root.granz.channel.E15.com. (
                     2023111302         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      granz.channel.E15.com.
@       IN      A       10.44.3.1 ; IP Lawine
www     IN      CNAME   granz.channel.E15.com.
' > /etc/bind/granz/granz.channel.E15.com

echo 'options {
        directory "/var/cache/bind";

        forwarders {
                   192.168.122.1;
          };
        //dnssec-validation auto;
        allow-query{ any; };
        listen-on-v6 { any; };
};' > /etc/bind/named.conf.options

service bind9 restart