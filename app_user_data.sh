cd ~/
wget https://github.com/Arun-hn/aws-3tier-web/archive/refs/heads/main.zip
unzip aws-3tier-web-main.zip
cp -r aws-3tier-web-main/app-tier app-tier
cd ~/app-tier
sed -i 's/DBENDPOINT/${WRITER-ENDPOINT}/g' DbConfig.js
sed -i 's/DBUSERNAME/${USERNAME}/g' DbConfig.js
sed -i 's/DBPASS/${PASSWORD}/g' DbConfig.js
npm install
pm2 start index.js
pm2 startup
sudo env PATH=$PATH:/home/ec2-user/.nvm/versions/node/v16.20.2/bin /home/ec2-user/.nvm/versions/node/v16.20.2/lib/node_modules/pm2/bin/pm2 startup systemd -u ec2-user --hp /home/ec2-user
pm2 save
sudo yum install mysql -y
mysql -h ${WRITER-ENDPOINT} -u ${USERNAME} -p${PASSWORD}
CREATE DATABASE webappdb;
USE webappdb;
CREATE TABLE IF NOT EXISTS transactions(id INT NOT NULL
AUTO_INCREMENT, amount DECIMAL(10,2), description
VARCHAR(100), PRIMARY KEY(id));
INSERT INTO transactions (amount,description) VALUES ('100','bags');
INSERT INTO transactions (amount,description) VALUES ('200','carts');
INSERT INTO transactions (amount,description) VALUES ('300','shelves');
INSERT INTO transactions (amount,description) VALUES ('400','groceries');
INSERT INTO transactions (amount,description) VALUES ('500','gas');

EOF
