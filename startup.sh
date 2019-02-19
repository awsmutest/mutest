#!/bin/bash



apt-get -y install python2.7 curl
curl -O https://bootstrap.pypa.io/get-pip.py
python2.7 get-pip.py
pip install awscli
# Getting region
EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"
# Trying to retrieve parameters from the EC2 Parameter Store
PRODTEST_WITH_ENCRYPTION=`aws ssm get-parameters --names prodtestpara --with-decryption --region $EC2_REGION --output text 2>&1`
PRODTEST_WITHOUT_ENCRYPTION=`aws ssm get-parameters --names prodtestpara --no-with-decryption --region $EC2_REGION --output text 2>&1`



set -x

IP=$(hostname -i)
NETWORK=$(echo ${IP} | cut -f3 -d.)

case "${NETWORK}" in
  100)
    zone=a
    color=Crimson
    ;;
  101)
    zone=b
    color=CornflowerBlue
    ;;
  102)
    zone=c
    color=LightGreen
    ;;
  *)
    zone=unknown
    color=Yellow
    ;;
esac

# kubernetes sets routes differently -- so we will discover our IP differently
if [[ ${IP} == "" ]]; then
  IP=$(hostname -i)
fi

# Am I on ec2 instances?
if [[ ${zone} == "unknown" ]]; then
  zone=$(curl -m2 -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.availabilityZone' | grep -o .$)
fi

export CODE_HASH="$(cat code_hash.txt)"
export IP
export AZ="${IP} in AZ-${zone}"

# exec container command
exec node server.js
