#!/bin/bash

# run as root

if [[ ${UID} -ne 0 ]]
then 
    echo "u should be root" >&2
    exit 1
fi

# assume the first argument as the user to delete
USER=${1}

userdel -r ${USER}

# Make sure user got deleted 

if [[ ${?} -ne 0 ]]
then
    echo "OOps user delete didnt work" >&2
    exit 1
fi

echo "The user ${USER} is deleted"

exit 0

