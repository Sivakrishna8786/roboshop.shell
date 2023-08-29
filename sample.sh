#!/bin/bash

DATE=$(date +%F:%H:%M:%S)
LOGSDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGDSDIR/$SCRIPT_NAME-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];

then 
   echo -e "$R ERROR:: Please run the script with root user $N"
   exit 1
fi

VALIDATE(){
if [ $i -ne 0 ];
then 
    echo -e "$2 ... $R FAILURE $N"
    exit 1

else 
    echo -e "$2 ... $Y SUCCESS $N"
fi
}
