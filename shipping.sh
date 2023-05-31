echo -e "\e[31m install maven\e[0m"
yum install maven -y  &>>/tmp/roboshop.log

echo -e "\e[31m adding application user\e[0m"
useradd roboshop  &>>/tmp/roboshop.log

echo -e "\e[31m creating application directory\e[0m"
rm -rf /app  &>>/tmp/roboshop.log
mkdir /app   &>>/tmp/roboshop.log

echo -e "\e[31m download application content\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip   &>>/tmp/roboshop.log

echo -e "\e[31m extract application content\e[0m"
cd /app
unzip /tmp/shipping.zip  &>>/tmp/roboshop.log

echo -e "\e[31m download maven dependncies\e[0m" 
mvn clean package  &>>/tmp/roboshop.log
mv target/shipping-1.0.jar shipping.jar   &>>/tmp/roboshop.log


echo -e "\e[31m install mysql client\e[0m"
yum install mysql -y  &>>/tmp/roboshop.log

echo -e "\e[31m load schema \e[0m"
mysql -h mysql-dev.keedev.store -uroot -pRoboShop@1 < /app/schema/shipping.sql  &>>/tmp/roboshop.log

echo -e "\e[31m setup systemd file\e[0m"
cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service  &>>/tmp/roboshop.log

echo -e "\e[31m start shipping service\e[0m"
systemctl daemon-reload  &>>/tmp/roboshop.log
systemctl enable shipping  &>>/tmp/roboshop.log
systemctl restart shipping &>>/tmp/roboshop.log