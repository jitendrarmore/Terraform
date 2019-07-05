#!/bin/sh
set -x

sudo apt-get update
sudo apt install ngnix
sudo ufw allow in "Apache Full"
sudo chmod -R 0755 /var/www/html/
sudo systemctl enable nginx
sudo systemctl start nginx
sudo echo "<html><h1>Hello from Jitendra More - 9833550438</h2></html>" > /var/www/html/index.html
