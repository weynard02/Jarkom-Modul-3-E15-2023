# Jarkom-Modul-3-E15-2023

<table>
    <tr>
        <th colspan=2> Kelompok E15 </th>
    </tr>
    <tr>
        <th>NRP</th>
        <th>Nama Anggota</th>
    </tr>
    <tr>
        <td>5025211014</td>
        <td>Alexander Weynard Samsico</td>
    </tr>
  <tr>
        <td>5025211121</td>
        <td>Frederick Yonatan Susanto</td>
    </tr>
</table>

## Soal 0

> kalian diminta untuk melakukan register domain berupa riegel.canyon.yyy.com untuk worker Laravel dan granz.channel.yyy.com untuk worker PHP (0) mengarah pada worker yang memiliki IP [prefix IP].x.1.

Untuk mendaftarkan domain riegel dan granz, kita perlu membuat konfigurasi pada DNS server agar IP Worker [prefix IP].x.1 dapat mengarah ke nama domain yang kita mau.

Pertama, kita update dan install dulu `bind9` pada Heiter (DNS Server)

```sh
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install bind9 -y
```

Catatan: nameserver tersebut merupakan nameserver pada internet (NAT)

Kemudian, seperti pada modul sebelumnya, kita daftarkan domain riegel.canyon.E15.com dan granz.channel.E15.com pada `/etc/bind/named.conf.local` dengan tujuan untuk mengetahui arah pengaturan nama domain ini ada di mana.

```sh
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
```

Setelah itu, kita membuat konfigurasinya pada file-file yang kita tujukan.

- **riegel.canyon.E15.com**

  ```sh
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
  ```

  - Catatan: 10.44.4.1 merupakan IP Frieren, maka domain ini akan digunakan Frieren

- **granz.channel.E15.com**
  ```sh
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
  ```
  - Catatan: 10.44.3.1 merupakan IP Lawine, maka domain ini akan digunakan Lawine

Sehingga domain-domain ini sudah siap digunakan. Langkah terakhir yang dapat kita lakukan adalah untuk forward alamat IP NAT `192.168.122.1` agar dapat akses juga untuk IP lainnya

```sh
echo 'options {
        directory "/var/cache/bind";

        forwarders {
                   192.168.122.1;
          };
        //dnssec-validation auto;
        allow-query{ any; };
        listen-on-v6 { any; };
};' > /etc/bind/named.conf.options
```

Terakhir, tidak lupa untuk melakukan restart pada bind

```sh
service bind9 restart
```

### Screenshot:

## Soal 1
