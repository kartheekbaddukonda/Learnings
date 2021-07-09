#!/bin/bash

# Make sure the script is being executed with superuser privileges.

if [[ ${UID} -ne 0 ]]
then
    echo "This scripts requires root privilege" 
    exit 1
fi

# If the user doesn't supply at least one argument, then give them help.

if [[ ${#} -lt 1 ]]
then 
    echo "Please supply atleast one argument"
fi

# The first parameter is the user name.

USER_NAME=${1}
shift
# The rest of the parameters are for the account comments.

COMMENTS="${*}"

# Generate a password.

PASSWORD=$(date +%s%N | sha256sum | head -c32)

# Create the user with the password.

useradd -c "${COMMENTS}" -m ${USER_NAME} &> /dev/null

# Check to see if the useradd command succeeded.

if [[ ${?} -eq 0 ]]
then 
    echo "User ${USER_NAME} added succesfully"
else
    echo "Oops something went wrong while adding user"
fi

# Set the password.

echo ${PASSWORD} | passwd --stdin ${USER_NAME} &> /dev/null

# Check to see if the passwd command succeeded.

if [[ ${?} -eq 0 ]]
then 
    echo "Password ${PASSWORD} set for user ${USER_NAME} "
else
    echo "Oops something went wrong while setting password"
fi

# Force password change on first login.

passwd -e ${USER_NAME} > /dev/null

# Display the username, password, and the host where the user was created.

cat /etc/passwd | tail -4 