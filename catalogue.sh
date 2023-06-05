source common.sh
component=catalogue

nodejs

echo -e "${color} copy mongodb repo file ${nocolor}"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}

echo -e "${color} install mongodb client ${nocolor}"
yum install mongodb-org-shell -y &>>${log_file}

#schema
echo -e "${color} loading schema ${nocolor}"
mongo --host mongodb-dev.keedev.store <${app_path}/schema/$component.js  &>>${log_file}



