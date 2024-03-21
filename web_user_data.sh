#!/bin/bash
sudo -u ec2-user -i <<'EOF'
# Update system and install necessary packages
sudo yum update -y
sudo yum install -y curl unzip wget

# Install Node.js using NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install 16
nvm use 16

# Download and set up web application
cd ~/
wget https://github.com/theitguycj/3-tier-web-app-using-terraform-aws/archive/refs/heads/master.zip
unzip master.zip
cd 3-tier-web-app-using-terraform-aws-master/

# Update nginx configuration
sed -i "s/LOAD-BALANCER-DNS/${INT_LOAD_BALANCER_DNS}/g" nginx.conf

# Copy web tier files and install dependencies
cd ~/
cp -r 3-tier-web-app-using-terraform-aws-master/web-tier web-tier
cd ~/web-tier
npm install
npm run build

# Install and configure nginx
sudo amazon-linux-extras install nginx1 -y
sudo rm /etc/nginx/nginx.conf
sudo cp ~/3-tier-web-app-using-terraform-aws-master/nginx.conf /etc/nginx/nginx.conf
sudo service nginx restart
sudo chkconfig nginx on

# Adjust permissions
chmod -R 755 /home/ec2-user
EOF