echo -e "\e[32mcopy mongodb repo file\e[0m"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo  &>>/tmp/roboshop.log
stat_check $?

echo -e "\e[32minstalling mongodb server\e[0m"
yum install mongodb-org -y &>>/tmp/roboshop.log
stat_check $?

#modify the config file
echo -e "\e[32mupdate mongodb listen address\e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat_check $?

echo -e "\e[32mstart mongodb server\e[0m"
systemctl enable mongod &>>/tmp/roboshop.log
systemctl restart mongod &>>/tmp/roboshop.log
stat_check $?