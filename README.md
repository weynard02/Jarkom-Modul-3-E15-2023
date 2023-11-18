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

## Soal 13

> Karena para petualang kehabisan uang, mereka kembali bekerja untuk mengatur riegel.canyon.yyy.com. Semua data yang diperlukan, diatur pada Denken dan harus dapat diakses oleh Frieren, Flamme, dan Fern. (13)

a. Denken (Database Server)

Denken merupakan Database Server yang di mana akan mengurus data pada aplikasi Laravel nanti. Untuk merealisasikan hal tersebut, kita dapat menginstall **MariaDB server** beserta **mysql** sebagai bahan database server untuk Denken.

```sh
apt-get update
apt-get install mariadb-server -y
service mysql start
```

Dengan mysql yang sudah distart, maka mariadb server ini bisa digunakan. Kita perlu untuk mendaftar username dan password untuk mariaDB mysql ini.

```sh
echo "
CREATE USER 'kelompokE15'@'%' IDENTIFIED BY 'passwordE15';
CREATE USER 'kelompokE15'@'localhost' IDENTIFIED BY 'passwordE15';
CREATE DATABASE dbkelompokE15;
GRANT ALL PRIVILEGES ON *.* TO 'kelompokE15'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'kelompokE15'@'localhost';
FLUSH PRIVILEGES;
" > init.sql
```

Penjelasan:

- `CREATE USER` digunakan untuk membuat user dengan (IDENTIFIED BY) password yang diberikan. Di kasus ini, kami membuat user "kelompokE15" dengan @ bebas dan "localhost" dengan password "passwordE15".
- `CREARE DATABASE` digunakan untuk membuat suatu database yang akan kita gunakan. Di sini kami memberi nama "dbkelompokE15"
- `GRANT ALL PRIVILEGES` digunakan untuk memberikan hak-hak semua _privileges_ pada user yang kita punya.
- `FLUSH PRIVILEGES` digunakan untuk mereload privileges yang ada
- Perintah-perintah sql ini dimasukan pada `init.sql`

kemudian kita masukan file perintah-perintah mysql itu ke dalam mariaDB server mysql dengan menggunakan username `root` yang tanpa sebuah password/

```sh
mysql -u root < init.sql
```

Catatan: -u merupakan argumen username

Database ini akan digunakan oleh 3 worker Laravel. Oleh karena itu, kita tambahkan konfigurasi ini pada `/etc/mysql/my.cnf`.

```sh
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
```

Kemudian jangan lupa untuk melakukan restart pada mysqlnya

```sh
service mysql restart
```

b. Frieren, Flamme, dan Fern (Database Client)

Agar para client bisa mengakses data dari denken, kita cukup melakukan koneksi pada MariaDB tersebut dengan hanya menginstall MariaDB versi client.

```sh
apt-get update
apt-get install mariadb-client -y
```

Setelah kita menginstall package di atas, berikutnya kita hanya mencoba melakukan koneksi MariaDB dengan host dari Denken dengan menggunakan perintah berikut:

```sh
mariadb --host=10.44.2.1 --port=3306 --user=kelompokE15 --password
```

Penjelasan:

- `--host` merupakan pemilihan server database yang akan digunakan. Untuk kasus ini IP Denken yang akan digunakan sebagai server
- `--port` merupakan port yang digunakan (default = 3306)
- `--user` merupakan username yang akan digunakan
- `--password` memberitahu jika kita akan menginputkan password

Setelah itu, akan diminta untuk menginput password seperti yang kami atur pada server sebelumnya "passwordE15".

Jika berhasil, maka akan tampak CLI untuk MariaDB.

### Screenshot:

## Soal 14

> Frieren, Flamme, dan Fern memiliki Riegel Channel sesuai dengan quest guide berikut. Jangan lupa melakukan instalasi PHP8.0 dan Composer (14)

Untuk masing-masing worker, kita diminta untuk membangun konfigurasi Riegel Canyon dengan instalasi PHP8.0 dan Composer.

Mari kita melakukan instalasi PHP8.0 dahulu pada masing-masing worker: Frieren, Flamme, dan Fern.

```sh
apt-get update

# Install package untuk menambahkan repository PHP
apt-get install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2

# Download GPG-key untuk PHP
curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg

# Tambahkan entri repositori baru untuk paket PHP Ondrej Sury ke worker
sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

# Lakukan update lagi
apt-get update

# Install package PHP versi 8.0
apt-get install php8.0-mbstring php8.0-xml php8.0-cli php8.0-common php8.0-intl php8.0-opcache php8.0-readline php8.0-mysql php8.0-fpm php8.0-curl unzip wget -y

# Pengecekan apakah php sudah terinstall
php --version
```

Instalasi php 8.0 sudah selesai. Kemudian kita menginstall nginx untuk config worker nanti

```c
apt-get install nginx -y
```

Setelah itu, kita menginstall composer cukup dengan mendownload composer dari `getcomposer.org` dan melakukan pemindahan ke usr/bin

```sh
wget https://getcomposer.org/download/2.0.13/composer.phar
chmod +x composer.phar
mv composer.phar /usr/bin/composer

# Pengecekan versi Composer
composer -V
```

Composer sudah berhasil terinstall pada worker. Selanjutnya, kita akan melakukan git clone dari **quest guide** tersebut yaitu aplikasi Laravel.

```sh
# Melakukan instalasi git terlebih dahulu
apt-get install git -y

# git clone untuk mendapatkan Laravel Projectnya
git clone https://github.com/martuafernando/laravel-praktikum-jarkom.git
```

Kemudian kita mengakses ke dalam projectnya dan melakukan `composer update` dan `composer install` untuk menginstall libraries atau dependencies yang dibutuhkan

Setelah itu, kita membuat .env nya dengan cara melakukan copy dari .env.example
`cp .env.example .env`

dan lakukan perubahan pada bagian databasenya mulai dari host, port, nama database, username, dan passwordnya

```sh
DB_CONNECTION=mysql
DB_HOST=10.44.2.1
DB_PORT=3306
DB_DATABASE=dbkelompokE15
DB_USERNAME=kelompokE15
DB_PASSWORD=passwordE15
```

Penjelasan:

- `DB_HOST` merupakan host IP Denken (Database Server)
- `DB_DATABASE, DB_USERNAME, DB_PASSWORD` sesuai dengan pengaturan sebelumnya

Masih di dalam project tersebut, kita jalankan perintah ini pada salah satu worker saja

```sh
php artisan migrate:fresh
php artisan db:seed --class=AiringsTableSeeder
```

Penjelasan:

- `php artisan migrate:fresh` merupakan perintah untuk melakukan migrasi pada tabel-tabel database seperti kolom, tipe data, dan lain-lain sesuai migration dari project Laravel
- `php artisan db:seed --class=AiringsTableSeeder` merupakan pengisian data pada Airings Table

Lakukan generation key dan jwt pada project Laravel

```sh
php artisan key:generate
php artisan jwt:secret
```

Penjelasan:

- `php artisan jwt:secret` dilakukan karena project menggunakan authentikasi JWT untuk membuat secret keynya

Konfigurasi project Laravel sudah selesai. Selanjutnyam kita melakukan konfigurasi nginx

```sh
echo '
server {

    listen 80;

    root /var/www/laravel-praktikum-jarkom/public;

    index index.php index.html index.htm;
    server_name _;

    location / {
            try_files $uri $uri/ /index.php?$query_string;
    }

    # pass PHP scripts to FastCGI server
    location ~ \.php$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
    }

location ~ /\.ht {
            deny all;
    }

    error_log /var/log/nginx/riegel_error.log;
    access_log /var/log/nginx/riegel_access.log;
}
' > /etc/nginx/sites-available/riegel
ln -s /etc/nginx/sites-available/riegel /etc/nginx/sites-enabled/
mv /laravel-praktikum-jarkom /var/www
```

Penjelasan:

- Menggunakan port worker default = 80
- Menggunakan root `/var/www/laravel-praktikum-jarkom/public`
- `ln -s /etc/nginx/sites-available/riegel /etc/nginx/sites-enabled/` untuk symlink
- `mv /laravel-praktikum-jarkom /var/www` memindahkan project Laravel pada dalam folder /var/www

Kemudian, kita memberikan server web www-data izin untuk menggunakan direktori penyimpanan

```sh
chown -R www-data.www-data /var/www/laravel-praktikum-jarkom/storage
```

Tidak lupa juga untuk menghapus page nginx default

```sh
rm -rf /etc/nginx/sites-enabled/default
```

Terakhir, kita menjalankan `php8.0-fpm` dan `nginx`

```sh
service php8.0-fpm start
service nginx restart
```

Untuk pengujian, kita dapat melakukan lynx pada masing-masing IP Worker Laravel

```sh
apt-get install lynx -y
lynx 10.44.4.1 # IP Frieren
lynx 10.44.4.2 # IP Flamme
lynx 10.44.4.3 # IP Fern
```

### Screenshot:

---

## Kendala:

- Setiap kali worker Laravel direload akan memunculkan error bahwa php.list sudah ada. Solusinya hanya melakukan penghapusan pada php.list tersebut:

  ```sh
  rm etc/apt/sources.list.d/php.list
  ```
