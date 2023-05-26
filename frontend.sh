echo -e "\e[32minstalling nginx server\e[0m"
yum install nginx -y

echo -e "\e[33mremoving old app content\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[31mkdownloading frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[31mextract frontend content\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

#you need to congif the files
echo -e "\e[31mrestarting nginx server\e[0m"
systemctl enable nginx
systemctl restart nginx