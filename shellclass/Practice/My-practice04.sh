#!/bin/bash

# Ask for username.
read -p 'Please provide user name: ' USER_NAME

# Ask for Real name.
read -p 'Please provide Real name: ' COMMENT


# Ask for password.
read -p 'Please provide password:' PASSWORD

# Create the user.

useradd -c "${COMMENT}" -m ${USER_NAME}

# Set the password for the user.

echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# FOrce the user to change pwd on first login.

passwd -e ${USER_NAME}

# Changed to NJ_Learning_!@