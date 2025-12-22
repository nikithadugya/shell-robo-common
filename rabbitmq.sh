#!/bin/bash
############# EVRYTHING WHOCH IS COMMON AND REUSABLE CODE WE WILL KEEP IN SEPERATE FILE AND IN THAT FILE WE WRITE ALL THE FUNCTIONS AND USE THOSE FUNCTIONS IN WHICH EVER CLASSES USING THAT COMMON CODE AND BEFORE THAT WRITE SOURCE ./COMMON.SH SO THAT ALL FUNCTIONS PRESENT INIT CAN BE ACCSSED HERE


source ./common.sh # So all functions in this class can be accssed in this present class

check_root

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOG_FILE
VALIDATE $? "Adding RabbitMQ repo"

dnf install rabbitmq-server -y &>>$LOG_FILE
VALIDATE $? "Installing RabbitMQ Server"

systemctl enable rabbitmq-server &>>$LOG_FILE
VALIDATE $? "Enabling rabbitmq Server"

systemctl start rabbitmq-server &>>$LOG_FILE
VALIDATE $? "starting rabbitmq Server"

rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
VALIDATE $? "Setting up permissions"

print_total_time


# Execute in MobaXterm on server like sudo sh mongo.sh