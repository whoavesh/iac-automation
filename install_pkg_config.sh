#!/bin/bash
sudo apt-get update -y
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo cd /var/www/html/
sudo rm -rf index.html
sudo mv /var/lib/jenkins/workspace/iac-pipeline/index.html /var/www/html/
sudo apt-get install stress -y
