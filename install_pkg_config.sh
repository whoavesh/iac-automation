#!/bin/bash

# Update package manager
sudo apt-get update -y

# Install nginx
sudo apt-get install nginx -y

# Ensure nginx is running and enabled
sudo systemctl start nginx
sudo systemctl enable nginx

# Clean up files in Nginx document root
sudo rm -rf /var/www/html/index.nginx-debian.html
sudo rm -rf /usr/share/nginx/html/index.html

# Download index.html from GitHub raw content
sudo wget -O /usr/share/nginx/html/index.html https://raw.githubusercontent.com/whoavesh/iac-automation/main/index.html


# Restart Nginx to apply changes
sudo systemctl restart nginx

# Install Stress for cpu testing
sudo apt-get install stress -y
