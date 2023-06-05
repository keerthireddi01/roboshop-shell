source common.sh
component=shipping

echo -e "${color} install maven${nocolor}"
yum install maven -y  &>>${log_file}

echo -e "${color} adding application user${nocolor}"
useradd roboshop  &>>${log_file}

echo -e "${color} creating application directory${nocolor}"
rm -rf ${app_path}&>>${log_file}
mkdir ${app_path}

echo -e "${color} download application content${nocolor}"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip   &>>${log_file}

echo -e "${color} extract application content${nocolor}"
cd /app
unzip /tmp/${component}.zip  &>>${log_file}

echo -e "${color} download maven dependncies${nocolor}" 
mvn clean package  &>>${log_file}
mv target/${component}-1.0.jar ${component}.jar   &>>${log_file}


echo -e "${color} install mysql client${nocolor}"
yum install mysql -y  &>>${log_file}

echo -e "${color} load schema ${nocolor}"
mysql -h mysql-dev.keedev.store -uroot -pRoboShop@1 < /app/schema/${component}.sql  &>>${log_file}

echo -e "${color} setup systemd file${nocolor}"
cp /home/centos/roboshop-shell/${component}.service /etc/systemd/system/${component}.service  &>>${log_file}

echo -e "${color} start ${component} service${nocolor}"
systemctl daemon-reload  &>>${log_file}
systemctl enable ${component}  &>>${log_file}
systemctl restart ${component} &>>${log_file}