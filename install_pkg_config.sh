#!/bin/bash

# Update package manager
sudo apt-get update -y

# Install nginx
sudo apt-get install nginx -y

# Ensure nginx is running and enabled
sudo systemctl start nginx
sudo systemctl enable nginx

#Clean Up files
sudo cd /var/www/html/
sudo rm -rf index.nginx-debian.html
sudo rm -rf index.html

wget https://github.com/whoavesh/iac-automation/blob/main/index.html

# Install Stress for cpu testing
sudo apt-get install stress -y
