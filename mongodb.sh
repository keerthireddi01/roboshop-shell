echo -e "\e[32mcopy mongodb repo file\e[0m"
cp mongodb.repo /etc/yum.repos.d/mongodb.repo

echo -e "\e[32minstalling mongodb server\e[0m"
yum install mongodb-org -y 

#modify the config file

echo -e "\e[32mstart mongodb server\e[0m"
systemctl enable mongod 
systemctl restart mongod 