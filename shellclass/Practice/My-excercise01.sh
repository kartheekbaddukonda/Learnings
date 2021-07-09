#!/bin/bash

# Make sure the script is being executed with superuser privileges.
if [[ ${UID} -ne 0 ]]
then
    echo "This script execution requires root previleges"
    exit 1
else 
    echo "The script is being executed with $(id -un) privileges"
fi

# Get the username (login).
read -p 'Please provide user name: ' USER_NAME

# Get the real name (contents for the description field).
read -p 'Please provide Real name: ' COMMENT

# Ask for password.
read -p 'Please provide password: ' PASSWORD

# Create the user with the password.
useradd -c "${COMMENT}" -m ${USER_NAME}

# Check to see if the useradd command succeeded.
if [[ ${?} = 0 ]]
then 
    echo "USer added succesfully, good go to for Password set"
else 
    echo "Opps something went wrong, user not added"
    exit 1
fi
# Set the password.

echo ${PASSWORD} | passwd --stdin ${USER_NAME} 

# Check to see if the passwd command succeeded.
if [[ ${?} = 0 ]]
then 
    echo "Password set succesfully"
else 
    echo "Opps something went wrong, Password not set"
    exit 1    
fi

# Force password change on first login.
passwd -e ${USER_NAME}

# Display the username, password, and the host where the user was created.

echo 'username:'
echo "${USER_NAME}"
echo
echo 'password:'
echo "${PASSWORD}"
echo
echo 'host:'
echo "${HOSTNAME}"
exit 0