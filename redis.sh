source common.sh

echo -e "${color}installing redis repos${nocolor}"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}
stat_check $?

echo -e "${color} enable redis 6 version${nocolor}"
yum module enable redis:remi-6.2 -y &>>${log_file}
stat_check $?

echo -e "${color}installing redis server${nocolor}"
yum install redis -y  &>>${log_file}
stat_check $?

#edit config file
echo -e "${color} updating redis ip address ${nocolor}"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf  /etc/redis/redis.conf &>>${log_file}
stat_check $?

echo -e "${color} start redis serviceserver${nocolor}"
systemctl enable redis &>>${log_file}
systemctl restart redis &>>${log_file}
stat_check $?