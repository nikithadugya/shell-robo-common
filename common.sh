#!/bin/bash

# This script is for validating the user at 20 line no and then following manual documentation and write script accordingly at 35 line no and then installing.

R="\e[31m"
G="\e[32m"
Y="\[e33m"
Normal="\e[0m"


LOGS_FOLDER="/var/log/shell-robo"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 ) # $0 --> Current file name  --> 14-logs
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
START_TIME=$(date +%s)
MONGODB_HOST="mongodb.dawsnikitha.fun"
SCRIPT_DIR="$PWD"


mkdir -p $LOGS_FOLDER  # -p means if directory is not there it creates if directory is there is keeps quiet
echo "Script started executed at: $(date)" | tee -a $LOG_FILE  # tee command appends the output printing of this command on mobexterm same in LOg file as well.
USERID=$(id -u)

check_root(){
    if [ $USERID -ne 0 ]; then
         echo "ERROR:: Please run this script with root(sudo) privilage"
        exit 1 #any number is failure other than 0
    fi
}


VALIDATE(){
if [ $1 -ne 0 ]; then
    echo -e "Installation $2... $R FAILURE $N"
    exit 1
else
    echo -e "Installation $2 ... $G success $N"
fi
}


### NODEJS ###
nodejs_setup(){
    dnf module disable nodejs -y &>>$LOG_FILE
    VALIDATE $? "Disabling NodeJS"
    dnf module enable nodejs:20 -y &>>$LOG_FILE
    VALIDATE $? "Enabling NodeJS"
    dnf install nodejs -y
    VALIDATE $? "Installing NodeJS"
}


##app-setup
app_setup(){
      id roboshop &>>$LOG_FILE
    if [ $? -ne 0 ]; then
         useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
        VALIDATE $? "Creating System User"
    else
         echo -e "User already exist.... $Y SKIPPING $N"
    fi

    mkdir -p /app  # If already directory is present then -p mentioning ignores and next if not there it creates
    VALIDATE $? "Creating App Directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOG_FILE
    VALIDATE $? "DOwnloading $app_name application"

    cd /app 
    VALIDATE $? "Changing to App Directory" # Here we got error because if files already present in app folder then it throws error so before only we are deleting
    
    rm -rf /app/*
    unzip /tmp/$app_name.zip &>>$LOG_FILE
    VALIDATE $? "Unzip $app_name"
}


java_setup(){
    mvn clean package
    VALIDATE $? "Cleaning package"
 
    mv target/shipping-1.0.jar shipping.jar 
    VALIDATE $? "Renaming the artifact"

}

systemd_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "Copy systemctl services"
    systemctl daemon-reload
    VALIDATE $? "demon reload"
    systemctl enable $app_name &>>$LOG_FILE
    VALIDATE $? "enabling $app_name"
}

#Printing time
print_total_time(){

END_TIME=$(date +%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))
echo -e "Script executed in: $Y $TOTAL_TIME Seconds"
}