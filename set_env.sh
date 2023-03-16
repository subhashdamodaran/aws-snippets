#!/usr/bin/env bash

#to make daily aws cli activities and switching between profiles easier when  work with large set of aws profiles and roles 
# List the profiles from credentials file

INI_FILE=~/.aws/credentials
ITER=0
PROFILE_ARR=()
while IFS=' = ' read key value
do
    if [[ $key == \[*] ]]; then
        section=$(echo $key | sed 's/[][]//g')
        PROFILE_ARR+=($section)
        ITER=$(expr $ITER + 1)
        echo $ITER. $section
    fi
done < $INI_FILE

echo "Select the profile by index "  
read profile_index

SELECTED_PROFILE=${PROFILE_ARR[$profile_index]}

# set the AWS and K8S ENV variables
export AWS_PROFILE=$SELECTED_PROFILE

echo "profile :" $AWS_PROFILE
# Get the EKS clusters from the selected account.

profile_region=`aws configure get region --profile "${AWS_PROFILE}"`
echo "region :" $profile_region

aws configure set region $profile_region --profile $AWS_PROFILE
