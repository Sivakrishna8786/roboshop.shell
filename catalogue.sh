#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$SCRIPT_NAME-$DATE.log
USERID=(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ];
then 
  echo -e " $R ERROR:: Start installation from root user $N"
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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE

VALIDATE $? "starting up rpm" 

yum install nodejs -y &>> $LOGFILE

VALIDATE $? "Installation of nodejs"

useradd roboshop &>> $LOGFILE

mkdir /app &>> $LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip 

VALIDATE $? "downloading catalogue"

cd /app   

unzip /tmp/catalogue.zip &>> $LOGFILE

npm install  &>> $LOGFILE

VALIDATE $? "Installation of npm"

 
cp /home/centos/roboshop-shell/catalogue.services /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "copying catalogue services"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "daemon reload"


systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "enable catalogue"

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "start catalogue"


cp /home/centos/roboshop-shell/catalogue.services /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "mongo client"

yum install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "install mongodb"


mongo --host mongodb.devopslearning.online </app/schema/catalogue.js &>> $LOGFILE


