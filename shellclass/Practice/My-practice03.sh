#!/bin/bash

# Display UID
echo "USer id is : ${UID}"

# Only display if the UID does not match 1000
UID_TO_TEST_FOR='1000'
if [[ ${UID} -ne ${UID_TO_TEST_FOR} ]]
then
    echo "${UID} is not matching with ${UID_TO_TEST_FOR}"
    exit 1
else
    echo "current user ${UID} is matching, so script will execute "
fi

# Display the user name
USERNAME=$(id -un)
echo "User executing the script is : ${USERNAME}"

# Test if command succeeded
STATUS="$?"
if [[ ${STATUS} = 0 ]]  # if [[ ${?} = 0 ]] 
then 
echo "Command executed succesfully"
else 
    echo "OOPS, Something went wrong!"
    exit 1
fi

# USe a string test conditional 
UN_TO_TEST_FOR='vagrant'
if [[ ${USERNAME} != ${UN_TO_TEST_FOR} ]]
then
    echo "${USERNAME} is not matching with ${UN_TO_TEST_FOR}"
    exit 1
else
    echo "current user ${USERNAME} is matching, so script will execute "
fi

exit 0

