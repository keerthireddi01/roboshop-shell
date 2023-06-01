
echo -e "\e[31m installing python\e[0m"
yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log

echo -e "\e[31m adding application user\e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[31m creting application directory\e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app  

echo -e "\e[31m dowmloading application content\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip  &>>/tmp/roboshop.log
cd /app 

echo -e "\e[31m extracting app content\e[0m"
unzip /tmp/payment.zip &>>/tmp/roboshop.log

echo -e "\e[31m  installing app dependencies\e[0m"
cd /app 
pip3.6 install -r requirements.txt  &>>/tmp/roboshop.log

#configure
echo -e "\e[31m setup systemd content\e[0m"
cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>>/tmp/roboshop.log

echo -e "\e[31m retart payment service\e[0m"
systemctl daemon-reload  &>>/tmp/roboshop.log
systemctl enable payment  &>>/tmp/roboshop.log
systemctl start payment &>>/tmp/roboshop.log