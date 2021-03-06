#!/bin/bash

source components/common.sh

# #Used export instead of service file
# DOMAIN=zsdevops.online

OS_PREREQ

Head "Installing go"
wget -c https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local &>>$LOG
#apt install golang -y &>>$LOG
go version
export PATH=$PATH:/usr/local/go/bin
Stat $?

Head "Making Directory"
mkdir -p ~/go/src &>>$LOG
cd  ~/go/src/
Stat $?

DOWNLOAD_COMPONENT

Head "Installing go Dependencies"
apt-get install go-dep &>>$LOG
go get &>>$LOG
go build &>>$LOG
Stat $?

Head "configure environmental variables"
# export AUTH_API_PORT=8080
# export USERS_API_ADDRESS=http://users.$DOMAIN:8080
sed -i -e "s/LOGIN_ENDPOINT/8080/g" -e "s/USERS_ENDPOINT/users.ksrihari.online/g" /root/go/src/login/systemd.service
Stat $?

Head "Setup SystemD Service"
mv /root/go/src/login/systemd.service /etc/systemd/system/login.service && systemctl daemon-reload && systemctl start login && systemctl enable login &>>$LOG
Stat $?