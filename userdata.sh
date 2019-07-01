#!/bin/sh
set -x
# output log of userdata to /var/log/user-data.log
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

sudo apt-get update
sudo apt install apache2
sudo ufw allow in "Apache Full"
sudo chmod -R 0755 /var/www/html/
sudo systemctl enable apache2
sudo systemctl start apache2
echo "<html><h1>Hello from Jitendra More - 9833550438</h2></html>" > /var/www/html/index.html
