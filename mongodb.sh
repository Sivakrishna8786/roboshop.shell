#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)

R="\e[31m"
G="\e[32m" 
Y="\e[33m"
N="\e[0"

if [ $USERID -ne 0 ];
then 
   echo -e "$R ERROR:: please run this script with root access $N"
   exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then 
        echo -e "$2 ... $R FAILURE $N"
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copied mongo repo into yum.repos.d"

yum install mongodb.org -y &>> $LOGFILE

VALIDATE $? "Installing of Mongodb"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enabling MongoDB"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "Edited Mongodb conf"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "restating Mongodb"
