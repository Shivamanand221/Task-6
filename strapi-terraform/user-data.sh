#!/bin/bash
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
# Pull and run Strapi container 
sudo docker pull shivamanand221/strapi:latest
sudo docker run -d -p 1337:1337 shivamanand221/strapi:latest
