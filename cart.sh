echo -e "\e[31mconfiguring nodejs repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "\e[31m installing Nodejs\e[0m"
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[31m adding application user\e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[31m create application directory\e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app 

echo -e "\e[31m download application content\e[0m"
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>>/tmp/roboshop.log
cd /app 

echo -e "\e[31mextract aplication content\e[0m"
unzip /tmp/cart.zip &>>/tmp/roboshop.log
cd /app 

echo -e "\e[31m Installing nodejs dependencies\e[0m"
npm install &>>/tmp/roboshop.log

#service file conf
echo -e "\e[31m setup systemdp service\e[0m"
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>>/tmp/roboshop.log

echo -e "\e[31m start cart services\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable cart  &>>/tmp/roboshop.log
systemctl start cart &>>/tmp/roboshop.log




