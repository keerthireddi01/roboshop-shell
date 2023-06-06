source common.sh

echo -e "${color}configure erlang  repos ${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>>${log_file}
stat_check $?

echo -e "${color}configure rabbitmq repos ${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log_file}
stat_check $?

echo -e "${color}install rabbitm server${nocolor}"
yum install rabbitmq-server -y  &>>${log_file}
stat_check $?

echo -e "${color}start rabbitmq service${nocolor}"
systemctl enable rabbitmq-server &>>${log_file}
systemctl restart rabbitmq-server &>>${log_file}
stat_check $?

echo -e "${color}add rabbitmq application user${nocolor}"
rabbitmqctl add_user roboshop $1  &>>${log_file}
stat_check $?
 
echo -e "${color}addset rabbitmq application user${nocolor}"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>${log_file}
stat_check $?