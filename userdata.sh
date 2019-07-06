#!/bin/sh
set -x

sudo apt-get update
sudo apt install ngnix
sudo ufw allow in "Apache Full"
sudo chmod -R 0755 /var/www/html/
sudo sed -i 's/80/8080/g' /etc/nginx/sites-enabled/default
sudo service nginx restart
sudo echo "<html><h1>Hello from Jitendra More - 9833550438</h2></html>" > /var/www/html/index.html
