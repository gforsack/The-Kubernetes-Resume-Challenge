# Introduction

This is a sample e-commerce application built for learning purposes.

Here's how to deploy it on Ubuntu systems:

## Deploy Pre-Requisites

1. Install Firewall

```bash
sudo apt-get update
sudo apt-get install -y ufw
sudo ufw allow 22/tcp
sudo ufw enable
sudo ufw status
```

## Deploy and Configure Database

1. Install MariaDB

```
sudo apt-get update
sudo apt-get install -y mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb
```

2. Configure firewall for Database

```
sudo ufw allow 3306/tcp
sudo ufw reload
```

3. Configure Database

```
sudo mysql
MariaDB > CREATE DATABASE ecomdb;
MariaDB > CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
MariaDB > GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
MariaDB > FLUSH PRIVILEGES;
exit
```

4. Load Product Inventory Information to the database

  Create the `db-load-script.sql`

```
cat > db-load-script.sql <<-EOF
USE ecomdb;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;

INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");

EOF
```

Run the SQL script

```
sudo mysql < db-load-script.sql
```

## Deploy and Configure Web

1. Install required packages

```
sudo apt-get update
sudo apt-get install -y apache2 php libapache2-mod-php php-mysql
sudo ufw allow 80/tcp
sudo ufw reload
```

2. Configure apache2

Change `DirectoryIndex index.html` to `DirectoryIndex index.php` to make the PHP page the default page

```
sudo sed -i 's/index.html/index.php/g' /etc/apache2/apache2.conf
```

3. Restart apache2

```
sudo systemctl restart apache2
```

4. Download code

```
sudo apt-get install -y git
sudo git clone https://github.com/gforsack/learning-app-ecommerce.git /var/www/html/
```

5. Update the `index.php`

Update index.php file to connect to the right database server. In this case, localhost since the database is on the same server.

```
sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php
```

ON a multi-node setup remember to provide the IP address of the database server here.

6. Test

```
curl http://localhost
```



