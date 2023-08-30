#!/bin/bash

NAMES=("workstation" "n")
INSTANCE_TYPE=""
IMAGE_ID=ami-081609eef2e3cc958
SECURITY_GROUP_ID=sg-0b680dc8e455e994b
DOMAIN_NAME=devopslearning.online

# if mysql or mongodb instance_type should be t3.medium , for all others it is t2.micro

for i in "${NAMES[@]}"
do  
    if [[ $i == "workstation" || $i == "" ]]
    then
        INSTANCE_TYPE="t3.medium"
    else
        INSTANCE_TYPE="t2.micro"
    fi
    echo "creating $i instance"
    aws ec2 run-instances --image-id $IMAGE_ID  --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]"
    done