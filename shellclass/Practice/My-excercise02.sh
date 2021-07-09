#!/bin/bash

# Make sure the script is being executed with superuser privileges.
if [[ ${UID} -ne 0 ]]
then
    echo
    echo "This script execution requires root previleges"
    exit 1
else 
    echo
    echo "The script is being executed with $(id -un) privileges"
fi

# If the user doesn't supply at least one argument, then give them help.

if [[ "${#}" -lt 1 ]]
then 
    echo
    echo "This script requires atleast 1 argument but supplied: ${#}"
    exit 1
fi

# The first parameter is the user name.

USER_NAME=${1}
echo
echo "USer name is: ${USER_NAME}"
shift

# The rest of the parameters are for the account comments.
COMMENTS="${*}"
echo
echo "Full name: ${COMMENTS}"

# Generate a password.
PASSWORD="$(date +%s%N | sha256sum | head -c32)"
echo
echo "Password: ${PASSWORD}"

# Create the user with the password.

useradd -c "${COMMENTS}" -m ${USER_NAME}

# Check to see if the useradd command succeeded.

if [[ ${?} -ne 0 ]]
then
    echo
    echo "OOPS something went Wrong while creating username"
    exit 1
fi

# Set the password.

echo ${PASSWORD} | passwd --stdin ${USER_NAME} 

# Check to see if the passwd command succeeded.

if [[ ${?} -ne 0 ]]
then
    echo
    echo "OOPS something went Wrong while setting password"
    exit 1
fi

# Force password change on first login.

passwd -e ${USER_NAME}

# Display the username, password, and the host where the user was created.
echo
echo "USername: ${USER_NAME}"
echo
echo "Password: ${PASSWORD}"
echo
echo "Host name: ${HOSTNAME}"
echo