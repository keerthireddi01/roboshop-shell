color="\e[35m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"

app_presetup() {
  echo -e "${color} adding application user ${nocolor}"
 useradd roboshop &>>${log_file}
 if [ $? -eq 0]; then
   echo SUCCESS
 else
    echo FAILURE
 fi      


 echo -e "${color} create application directory ${nocolor}"
 rm -rf ${app_path} &>>${log_file}
 mkdir ${app_path} 
 if [ $? -eq 0]; then
   echo SUCCESS
 else
   echo FAILURE
 fi      


 echo -e "${color} download application content ${nocolor}"
 curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>${log_file}
 if [ $? -eq 0]; then
   echo SUCCESS
 else
   echo FAILURE
 fi      

 
 echo -e "${color} extract aplication content ${nocolor}"
 cd ${app_path} 
 unzip /tmp/$component.zip &>>${log_file}
 echo $?
}

systemd_setup() {
    
 #service file conf
 echo -e "${color} setup systemdp service ${nocolor}"
 cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>${log_file}
  
 if [ $? -eq 0]; then
   echo SUCCESS
 else
   echo FAILURE
 fi      

 echo -e "${color} start catalogue services ${nocolor}"
 systemctl daemon-reload &>>${log_file}
 systemctl enable $component  &>>${log_file}
 systemctl start $component &>>${log_file}
 if [ $? -eq 0]; then
   echo SUCCESS
 else
   echo FAILURE
 fi      
}


nodejs() {
 echo -e "${color} configuring nodejxss repos ${nocolor}"
 curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

 echo -e "${color} installing Nodejs ${nocolor}"
 yum install nodejs -y &>>${log_file}
 
 if [ $? -eq 0]; then
   echo SUCCESS
else
   echo FAILURE
fi      
 app_presetup

 echo -e "${color} Installing nodejs dependencies ${nocolor}"
 npm install &>>${log_file}

 #service file conf
 systemd_setup

}
#smongodb function

schema_setup() {

 echo -e "${color} copy mongodb repo file ${nocolor}"
 cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}

 echo -e "${color} install mongodb client ${nocolor}"
 yum install mongodb-org-shell -y &>>${log_file}

 #schema

 echo -e "${color} loading schema ${nocolor}"
 mongo --host mongodb-dev.keedev.store <${app_path}/schema/$component.js  &>>${log_file}

}

mysqlshchema_setup() {
 echo -e "${color} install mysql client${nocolor}"
 yum install mysql -y  &>>${log_file}
 echo $?

 echo -e "${color} load schema ${nocolor}"
 mysql -h mysql-dev.keedev.store -uroot -pRoboShop@1 < /app/schema/${component}.sql  &>>${log_file}
}


#maven function

maven() {
 echo -e "${color} install maven${nocolor}"
 yum install maven -y  &>>${log_file}

 app_presetup
 echo $?
 echo -e "${color} download maven dependncies${nocolor}" 
 mvn clean package  &>>${log_file}
 mv target/${component}-1.0.jar ${component}.jar   &>>${log_file}

 mysqlshchema_setup

 systemd_setup
 if [ $? -eq 0]; then
   echo SUCCESS
 else
   echo FAILURE
 fi      

}

python() {

echo -e "${color} installing python${nocolor}"
yum install python36 gcc python3-devel -y  &>>${log_file}
if [ $? -eq 0]; then
   echo SUCCESS
else
   echo FAILURE
fi      

app_presetup

echo -e "${color} installing app dependencies${nocolor}"
cd ${app_path}
pip3.6 install -r requirements.txt   &>>${log_file}
if [ $? -eq 0]; then
   echo SUCCESS
else
   echo FAILURE
fi      

#configure

 systemd_setup
}