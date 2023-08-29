#!/bin/bash

NAMES=("mongodb" "catalogue" "cart" "user" "redis" "mysql" "shipping" "rabbitmq" "payment" "dispatch" "web")
INSTANCE_TYPE=""
IMAGE_ID="ami-081609eef2e3cc958"
SECURITY_GROUP_ID="sg-0b680dc8e455e994b "

# if here instance_type of mysql and mongodb is t3.medium and the rest of the instances is t2.medium

for i in "${NAMES[@]}"
do 
  if [[ $i == "mongodb" || $i == "mysql" ]];
  then 
    INSTANCE_TYPE="t3.medium"
  else 
    INSTANCE_TYPE="t2.medium"
  fi
   echo "NAME:: $i"
   aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications 'ResourceType=instance,Tags=[{Key=NAME,Value=$i}]' 
done

