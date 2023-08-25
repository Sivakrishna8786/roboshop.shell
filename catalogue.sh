#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
 
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

   if [ $USERID -ne 0 ];
   then 
       echo -e "$R ERROR:: Please run this script with root user $N"
       exit 1
    fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then 
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi 
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "stasetting up NPM source" 

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "Installing nodejs"

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>$LOGFILE

VALIDATE $? "downloading catalogue artifact"

cd /app   

VALIDATE $? "moving into app directory"

unzip /tmp/catalogue.zip &>>$LOGFILE

VALIDATE $? "unzipping catalogue"

cd /app

npm install  &>>$LOGFILE

VALIDATE $? "Installing dependencies"

cp C:\devopslearn\draw.io\repos\roboshop-shell\catalogue.services /etc/systemd/system/catalogue.service &>>$LOGFILE

VALIDATE $? "copying catalogue services"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon reload"

systemctl enable catalogue &>>$LOGFILE

VALIDATE $? "enable catalogue"

systemctl start catalogue &>>$LOGFILE

VALIDATE $? "start catalogue"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "mongo client"

yum install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "install mongo client"

mongo --host mongodb.devopslearning.online </app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "loading catalogue data into mongodb"