# #!/bin/bash
# yum update -y
# yum install -y docker
# systemctl start docker
# systemctl enable docker
# usermod -aG docker ec2-user
# # Pull and run Strapi container 
# sudo docker pull shivamanand221/strapi:latest
# sudo docker run -d -p 1337:1337 shivamanand221/strapi:latest

#!/bin/bash
# Update and install Docker
yum update -y
amazon-linux-extras install docker -y
service docker start
usermod -aG docker ec2-user

# Install git and curl
yum install git curl -y

# Create app directory
mkdir -p /home/ec2-user/strapi-app
chown ec2-user:ec2-user /home/ec2-user/strapi-app

# Switch to that directory
cd /home/ec2-user/strapi-app

# Pull official Strapi image
docker pull strapi/strapi

# Create a Strapi app locally (this will generate structure first)
docker run --rm -v $(pwd):/srv/app strapi/strapi npx create-strapi-app@latest /srv/app --no-run --quickstart

# Start Strapi container with volume
docker run -d \
  --name strapi-app \
  -v /home/ec2-user/strapi-app:/srv/app \
  -w /srv/app \
  -p 1337:1337 \
  strapi/strapi npm run develop
