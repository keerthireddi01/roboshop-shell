echo -e "\e[31m install golang\e[0m"
yum install golang -y &>>/tmp/roboshop.log

echo -e "\e[31m adding application user\e[0m"
useradd roboshop  &>>/tmp/roboshop.log

echo -e "\e[31m creating app directory\e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app 

echo -e "\e[31m downloading app content\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip  &>>/tmp/roboshop.log
cd /app 

echo -e "\e[31m extracting applicatio content\e[0m"
unzip /tmp/dispatch.zip &>>/tmp/roboshop.log

echo -e "\e[31m golang commands\e[0m"
cd /app 
go mod init dispatch &>>/tmp/roboshop.log
go get  &>>/tmp/roboshop.log
go build  &>>/tmp/roboshop.log

#configure service file
echo -e "\e[31m systemd setup\e[0m"
cp /home/centos/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service &>>/tmp/roboshop.log 

echo -e "\e[31m restarting dipatch service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable dispatch  &>>/tmp/roboshop.log
systemctl restart dispatch &>>/tmp/roboshop.log