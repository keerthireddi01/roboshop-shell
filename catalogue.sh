component=catalogue
color="\e[36"
nocolor="\e[0m"
echo -e "${color} configuring nodejxss repos ${nocolor}"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "${color} installing Nodejs ${nocolor}"
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "${color} adding application user ${nocolor}"
useradd roboshop &>>/tmp/roboshop.log

echo -e "${color} create application directory ${nocolor}"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app 

echo -e "${color} download application content ${nocolor}"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>/tmp/roboshop.log
cd /app 

echo -e "${color} extract aplication content ${nocolor}"
unzip /tmp/$component.zip &>>/tmp/roboshop.log
cd /app 

echo -e "${color} Installing nodejs dependencies ${nocolor}"
npm install &>>/tmp/roboshop.log

#service file conf
echo -e "${color} setup systemdp service ${nocolor}"
cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>/tmp/roboshop.log

echo -e "${color} start catalogue services ${nocolor}"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable $component  &>>/tmp/roboshop.log
systemctl start $component &>>/tmp/roboshop.log

echo -e "${color} copy mongodb repo file ${nocolor}"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>/tmp/roboshop.log

echo -e "${color} install mongodb client ${nocolor}"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log

#schema
echo -e "${color} loading schema ${nocolor}"
mongo --host mongodb-dev.keedev.store </app/schema/$component.js  &>>/tmp/roboshop.log



