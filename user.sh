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
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>/tmp/roboshop.log
cd /app 

echo -e "\e[31mextract aplication content\e[0m"
unzip /tmp/user.zip &>>/tmp/roboshop.log
cd /app 

echo -e "\e[31m Installing nodejs dependencies\e[0m"
npm install &>>/tmp/roboshop.log

#service file conf
echo -e "\e[31m setup systemdp service\e[0m"
cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service &>>/tmp/roboshop.log

echo -e "\e[31m start user services\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable user  &>>/tmp/roboshop.log
systemctl start user &>>/tmp/roboshop.log

echo -e "\e[31m copy mongodb repo file\e[0m"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>/tmp/roboshop.log

echo -e "\e[31m install mongodb client\e[0m"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log

#schema
echo -e "\e[31m loading schemae[0m"
mongo --host mongodb-dev.keedev.store </app/schema/user.js  &>>/tmp/roboshop.log



