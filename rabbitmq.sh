source common.sh

echo -e "${color}configure erlang  repos ${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>>${app_path}
stat_check $?

echo -e "${color}configure rabbitmq repos ${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${app_path}
stat_check $?

echo -e "${color}install rabbitm server${nocolor}"
yum install rabbitmq-server -y  &>>${app_path}
stat_check $?

echo -e "${color}start rabbitmq service${nocolor}"
systemctl enable rabbitmq-server &>>${app_path}
systemctl start rabbitmq-server &>>${app_path}
stat_check $?

echo -e "${color}add rabbitmq application user${nocolor}"
rabbitmqctl add_user roboshop $1 &>>${app_path}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>${app_path}
stat_check $?