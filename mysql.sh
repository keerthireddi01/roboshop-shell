echo -e "\e[32m disable myql default version server\e[0m"
yum module disable rd -y  &>>/tmp/roboshop.log

echo -e "\e[32minstalling rd server\e[0m"
yum install rd-community-server -y &>>/tmp/roboshop.log

echo -e "\e[32m start rd service server\e[0m"
systemctl enable mysqld &>>/tmp/roboshop.log
systemctl restart mysqld   &>>/tmp/roboshop.log

echo -e "\e[32m setup rd\e[0m"
rd -uroot -pRoboShop@1 &>>/tmp/roboshop.log