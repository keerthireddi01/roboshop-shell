source common.sh

echo -e "${color}copy mongodb repo file${nocolor}"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo  &>>${log_file}
stat_check $?

echo -e "${color}installing mongodb server${nocolor}"
yum install mongodb-org -y &>>${log_file}
stat_check $?

#modify the config file
echo -e "${color}update mongodb listen address${nocolor}"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat_check $?

echo -e "${color}start mongodb server${nocolor}"
systemctl enable mongod &>>${log_file}
systemctl restart mongod &>>${log_file}
stat_check $?