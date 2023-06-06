color="\e[35m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"
user_id=$(id -u)

if [ $user_id -ne 0 ]; then
 echo "script should be running with sudo"
 exit 1
fi

stat_check() {
 if [ $? -eq 0 ]; then
   echo SUCCESS
 else
    echo FAILURE
    exit 1
 fi  
}

app_presetup() {
  echo -e "${color} adding application user ${nocolor}"
  id roboshop &>>${log_file}
 if [ $? -eq 1 ]; then
  useradd roboshop &>>${log_file}
 fi
 stat_check $? 

 echo -e "${color} create application directory ${nocolor}"
 rm -rf ${app_path} &>>${log_file}
 mkdir ${app_path} 
 stat_check $? 

 echo -e "${color} download application content ${nocolor}"
 curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>${log_file}
  stat_check $?     

 echo -e "${color} extract aplication content ${nocolor}"
 cd ${app_path} 
 unzip /tmp/$component.zip &>>${log_file}
  stat_check $? 
}

systemd_setup() {
 #service file conf
 echo -e "${color} setup systemdp service ${nocolor}"
 cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>${log_file}
 sed -i -e "s/roboshop_app_password/$roboshop_app_password/" /etc/systemd/system/$component.service
 stat_check $?     

 echo -e "${color} start catalogue services ${nocolor}"
 systemctl daemon-reload &>>${log_file}
 systemctl enable $component  &>>${log_file}
 systemctl start $component &>>${log_file}
 stat_check $? 
}

nodejs() {
 echo -e "${color} configuring nodejxss repos ${nocolor}"
 curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
 stat_check $? 

 echo -e "${color} installing Nodejs ${nocolor}"
 yum install nodejs -y &>>${log_file}
 stat_check $? 

 app_presetup

 echo -e "${color} Installing nodejs dependencies ${nocolor}"
 npm install &>>${log_file}
 stat_check $? 
 #service file conf
 systemd_setup
}


#smongodb function
schema_setup() {
 echo -e "${color} copy mongodb repo file ${nocolor}"
 cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
 stat_check $? 

 echo -e "${color} install mongodb client ${nocolor}"
 yum install mongodb-org-shell -y &>>${log_file}
 stat_check $? 
 
 #schema
 echo -e "${color} loading schema ${nocolor}"
 mongo --host mongodb-dev.keedev.store <${app_path}/schema/$component.js  &>>${log_file}
 stat_check $? 
}

mysqlshchema_setup() {
 echo -e "${color} install mysql client${nocolor}"
 yum install mysql -y  &>>${log_file}
 stat_check $? 

 echo -e "${color} load schema ${nocolor}"
 mysql -h mysql-dev.keedev.store -uroot -pRoboShop@1 < /app/schema/${component}.sql  &>>${log_file}
 stat_check $? 
}

#maven function
maven() {
 echo -e "${color} install maven${nocolor}"
 yum install maven -y  &>>${log_file}
 stat_check $? 

 app_presetup
 stat_check $? 

 echo -e "${color} download maven dependncies${nocolor}" 
 mvn clean package  &>>${log_file}
 mv target/${component}-1.0.jar ${component}.jar   &>>${log_file}
 stat_check $? 

 mysqlshchema_setup

 systemd_setup

 stat_check  $?   
}

python() {
echo -e "${color} installing python${nocolor}"
yum install python36 gcc python3-devel -y  &>>${log_file}
stat_check  $? 

app_presetup

echo -e "${color} installing app dependencies${nocolor}"
cd ${app_path}
pip3.6 install -r requirements.txt   &>>${log_file}
stat_check $?

#configure
 systemd_setup
}