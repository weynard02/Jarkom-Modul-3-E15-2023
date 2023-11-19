echo nameserver 192.168.122.1 > /etc/resolv.conf

apt-get update
apt-get install isc-dhcp-server -y
dhcpd --version

echo '
# Defaults for isc-dhcp-server (sourced by /etc/init.d/isc-dhcp-server)

# Path to dhcpd'\''s config file (default: /etc/dhcp/dhcpd.conf).
#DHCPDv4_CONF=/etc/dhcp/dhcpd.conf
#DHCPDv6_CONF=/etc/dhcp/dhcpd6.conf

# Path to dhcpd'\''s PID file (default: /var/run/dhcpd.pid).
#DHCPDv4_PID=/var/run/dhcpd.pid
#DHCPDv6_PID=/var/run/dhcpd6.pid

# Additional options to start dhcpd with.
#       Don'\''t use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead
#OPTIONS=""

# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
#       Separate multiple interfaces with spaces, e.g. "eth0 eth1".
INTERFACES="eth0"
' > /etc/default/isc-dhcp-server

echo "subnet 10.44.1.0 netmask 255.255.255.0 {
}

subnet 10.44.2.0 netmask 255.255.255.0 {
}

subnet 10.44.3.0 netmask 255.255.255.0 {
        range 10.44.3.16 10.44.3.32;
        range 10.44.3.64 10.44.3.80;
        option routers 10.44.3.9;
        option broadcast-address 10.44.3.255;
        option domain-name-servers 10.44.1.2;
        default-lease-time 180;
        max-lease-time 5760;

}

subnet 10.44.4.0 netmask 255.255.255.0 {
        range 10.44.4.12 10.44.4.20;
        range 10.44.4.160 10.44.4.168;
        option routers 10.44.4.9;
        option broadcast-address 10.44.4.255;
        option domain-name-servers 10.44.1.2;
        default-lease-time 720;
        max-lease-time 5760;
}

host Lawine {
        hardware ethernet ce:12:90:c4:d1:89;
        fixed-address 10.44.3.1;
}

host Linie {
        hardware ethernet 12:8d:e0:8b:be:ab;
        fixed-address 10.44.3.2;
}

host Lugner {
        hardware ethernet a2:50:1c:66:1a:24;
        fixed-address 10.44.3.3;
}

host Frieren {
        hardware ethernet ea:55:45:79:05:39;
        fixed-address 10.44.4.1;
}

host Flamme {
        hardware ethernet 92:b0:a7:d3:41:24;
        fixed-address 10.44.4.2;
}

host Fern {
        hardware ethernet 7e:a9:a1:90:cc:20;
        fixed-address 10.44.4.3;
}

" > /etc/dhcp/dhcpd.conf

rm /var/run/dhcpd.pid

service isc-dhcp-server restart