#!/bin/bash
############# EVRYTHING WHOCH IS COMMON AND REUSABLE CODE WE WILL KEEP IN SEPERATE FILE AND IN THAT FILE WE WRITE ALL THE FUNCTIONS AND USE THOSE FUNCTIONS IN WHICH EVER CLASSES USING THAT COMMON CODE AND BEFORE THAT WRITE SOURCE ./COMMON.SH SO THAT ALL FUNCTIONS PRESENT INIT CAN BE ACCSSED HERE


source ./common.sh # So all functions in this class can be accssed in this present class

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo # we have created mongo.repo file seperately and in that we have given all the content and now we are cp this to /etc/yum.repos.d/mongo.repo 
VALIDATE $? "Adding Mongo repo"

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "Installing MongoDB"

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "Enable MongoDB"

systemctl start mongod
VALIDATE $? "Start MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing remote connections to Mongodb"

systemctl restart mongod
VALIDATE $? "Restarted MongoDB"


print_total_time


# Execute in MobaXterm on server like sudo sh mongo.sh