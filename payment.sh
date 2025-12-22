#!/bin/bash
source ./common.sh
app_name=payment

check_root

dnf install python3 gcc python3-devel -y &>>$LOG_FILE
VALIDATE $? "Installing python-3"

app_setup

cd /app 
pip3 install -r requirements.txt &>>$LOG_FILE
VALIDATE $? "Installing dependencies"

systemd_setup()


print_total_time
