source common.sh
color="\e[35m"
nocolor="${nocolor}"
log_file="${log_file}"
app_path="/app"


echo -e "${color}installing nginx server${nocolor}"
yum install nginx -y  &>>${log_file}
stat_check $?

echo -e "${color}removing old app content${nocolor}"
rm -rf /usr/share/nginx/html/* &>>${log_file}
stat_check

echo -e "${color}downloading frontend content${nocolor}"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
stat_check $?

echo -e "${color}extract frontend content${nocolor}"
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>${log_file}
stat_check $?

#you need to congif the files
echo -e "${color}update  frontend configuration${nocolor}"
cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf
stat_check $?

echo -e "${color}restarting nginx server${nocolor}"
systemctl enable nginx  &>>${log_file}
systemctl restart nginx  &>>${log_file}
stat_check $?