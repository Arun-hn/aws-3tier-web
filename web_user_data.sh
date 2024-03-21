#!/bin/bash
sudo -u ec2-user -i <<'EOF'

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install 16
nvm use 16
cd ~/
wget https://github.com/Arun-hn/aws-3tier-web/archive/refs/heads/main.zip
unzip aws-3tier-web-main.zip
cd aws-3tier-web-main/
sed -i 's/LOAD-BALANCER-DNS/${INT-LOAD-BALANCER-DNS}/g' nginx.conf
cd ~/
cp aws-3tier-web-main/web-tier web-tier --recursive
cd ~/web-tier
npm install
npm run build
sudo amazon-linux-extras install nginx1 -y
cd /etc/nginx
sudo rm nginx.conf
sudo cp ~aws-3tier-web-main/nginx.conf nginx.conf
sudo service nginx restart
chmod -R 755 /home/ec2-user
sudo chkconfig nginx on

EOF
