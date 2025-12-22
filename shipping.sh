#!/bin/bash

source ./common.sh
app_name=shipping
check_root

dnf install maven -y
VALIDATE $? "Installing maven"
app_setup
java_setup
systemd_setup

dnf install mysql -y 

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities' &>>$LOG_FILE
if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOG_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
else
    echo -2 "Shipping data is already loaded ... $Y SKIPPING $N"
fi


systemctl restart shipping &>>$LOG_FILE
VALIDATE $? "ReStarted shipping"