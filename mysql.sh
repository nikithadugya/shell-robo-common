#!/bin/bash
############# EVRYTHING WHOCH IS COMMON AND REUSABLE CODE WE WILL KEEP IN SEPERATE FILE AND IN THAT FILE WE WRITE ALL THE FUNCTIONS AND USE THOSE FUNCTIONS IN WHICH EVER CLASSES USING THAT COMMON CODE AND BEFORE THAT WRITE SOURCE ./COMMON.SH SO THAT ALL FUNCTIONS PRESENT INIT CAN BE ACCSSED HERE


source ./common.sh # So all functions in this class can be accssed in this present class

check_root

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Enable MySQL-SERVER"

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "Enable mysqld"

systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "Start mysqld"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE
VALIDATE $? "Setting Root Password"

print_total_time


# Execute in MobaXterm on server like sudo sh mongo.sh