#!/bin/bash

# Update package manager
sudo apt-get update -y

# Install nginx
sudo apt-get install nginx -y

# Ensure nginx is running and enabled
sudo systemctl start nginx
sudo systemctl enable nginx

#Clean Up
sudo cd /var/www/html/
sudo rm -rf index.html

# Move index.html from Jenkins workspace to Nginx document root
sudo mv /var/lib/jenkins/workspace/iac-pipeline/index.html /var/www/html/

# Install Stress for cpu testing
sudo apt-get install stress -y
