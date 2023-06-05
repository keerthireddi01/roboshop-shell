echo -e "\e[31m configure erlang  repos \e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>>/tmp/roboshop.log

echo -e "\e[31m configure rabbitmq repos \e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>/tmp/roboshop.log

echo -e "\e[31m install rabbitm server\e[0m"
yum install rabbitmq-server -y  &>>/tmp/roboshop.log

echo -e "\e[31m start rabbitmq service\e[0m"
systemctl enable rabbitmq-server &>>/tmp/roboshop.log
systemctl start rabbitmq-server &>>/tmp/roboshop.log

echo -e "\e[31m add rabbitmq application user\e[0m"
rabbitmqctl add_user roboshop $1 &>>/tmp/roboshop.log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>/tmp/roboshop.log