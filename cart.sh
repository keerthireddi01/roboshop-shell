source common.sh

component=cart


echo -e "${color} configuring nodejs repos${nocolor}"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

echo -e "${color} installing Nodejs${nocolor}"
yum install nodejs -y &>>${log_file}

echo -e "${color} adding application user${nocolor}"
useradd roboshop &>>${log_file}

echo -e "${color} create application directory${nocolor}"
rm -rf ${app_path} &>>${log_file}
mkdir ${app_path} 

echo -e "${color} download application content${nocolor}"
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>>${log_file}
cd ${app_path} 

echo -e "${color}extract aplication content${nocolor}"
unzip /tmp/$component.zip &>>${log_file}
cd ${app_path} 

echo -e "${color} Installing nodejs dependencies${nocolor}"
npm install &>>${log_file}

#service file conf
echo -e "${color} setup systemdp service${nocolor}"
cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>${log_file}

echo -e "${color} start cart services${nocolor}"
systemctl daemon-reload &>>${log_file}
systemctl enable $component  &>>${log_file}
systemctl start $component &>>${log_file}




