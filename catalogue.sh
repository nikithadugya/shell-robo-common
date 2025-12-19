#!/bin/bash

source ./common.sh
app_name=catalogue  #### catalogue is the changing name so so developer gives that whatever we give it takes so giving it in a variable 

app_setup ### here app_setup doesnot require any dependency on nodejs_setup so first
nodejs_setup

systemd_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copy mongo repo"

dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "Install MONGODB Client"

#Checking whether the schema catalogue already present in the database mongo to avoid duplicate
INDEX=$(mongosh mongodb.dawsnikitha.fun --quiet --eval "db.getMongo().getDBNames().indexOf('catalog')")
if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Load $app_name produvts i.e, Loading Schemas from backend to database"
else
    echo -e "$app_name products already loaded... $Y SKIPPING $N"
fi

systemctl restart $app_name

print_total_time
