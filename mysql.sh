source common.sh

echo -e "${color} disable mysql default version server${nocolor}"
yum module disable mysql -y  &>>${log_file}
stat_check $?

echo -e "${color} copy mysql repo file${nocolor}"
cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
stat_check $?

echo -e "${color}installing mysql server${nocolor}"
yum install mysql-community-server -y &>>${log_file}
stat_check $?

echo -e "${color} start mysql service server${nocolor}"
systemctl enable mysqld  &>>${log_file}
systemctl restart mysqld   &>>${log_file}
stat_check $?

echo -e "${color} setup mysql${nocolor}"
mysql_secure_installation --set-root-pass $1  &>>${log_file}
#mysql -uroot -pRoboShop@1 &>>${log_file}
stat_check $?