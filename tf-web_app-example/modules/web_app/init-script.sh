#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo ${file_content} > /var/www/html/index.html
echo 'RewriteEngine On' >> /etc/httpd/conf/httpd.conf # adds a line to enable the rewrite engine
echo 'RewriteRule ^/[a-zA-Z0-9]+[/]?$ /index.html [QSA,L]' >> /etc/httpd/conf/httpd.conf # adds a line to redirect all requests that have alphanumeric charaters in path to index.html
systemctl restart httpd