source common.sh
component=dispatch

echo -e "${color}install golang${nocolor}"
yum install golang -y &>>${log_file}
stat_check $? 

app_presetup

echo -e "${color}golang commands${nocolor}"
cd ${app_path} 
go mod init $component &>>${log_file}
go get  &>>${log_file}
go build  &>>${log_file}
stat_check $? 

#configure service file
systemd_setup
stat_check $? 
