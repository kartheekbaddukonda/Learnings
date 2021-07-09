#!/bin/bash

# Display UID (as UID is not a custom variable instead coming from bash you can get more info of other variables from man bash)
# write what you wnna perform first  - this is called psuedocodeing
echo "Your UID is ${UID}"
echo "Your UID is ${EUID}"
echo "${BASH_VERSION}"
echo "${SECONDS}"

# Display user name
USER_NAME=$(id -un)
# USER_NAME=`id -un`
echo "USer name is: ${USER_NAME}" 

# Display if the user is root user or not

if [[ "${UID}" -ne 0 ]]
then 
    echo "you are not root user"
else 
    echo "You are root user"
fi