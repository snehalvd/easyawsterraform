#! /bin/bash
sudo i
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "This is a webserver created by terraform script" > /var/www/html/index.html
