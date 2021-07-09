#!/bin/bash

# Redirecting STDOUT to a file
FILE="/tmp/data"
head -1 /etc/passwd > ${FILE}

# Redirecting STDIN from a file

read LINE < ${FILE}
echo ${LINE}

# Redirecting STDOUT to a file , Overwrite the file
head -3 /etc/passwd > ${FILE}
echo
echo "file ${FILE} before apend"
cat ${FILE}
echo

# Redirecting STDOUT to a file , append content the file
tail -3 /etc/passwd >> ${FILE}
echo "file ${FILE} after data append"
cat ${FILE}


# redirecting stdout and std error to file
# head -n1 /etc/passwd /etc/hosts /fake_file 2> error.out 1>output.out

# Redirect standard in to a program using FD 0
read LINE 0< ${FILE}
echo
echo ${LINE}

# Redirecting STDOUT to a file using FD 1
FILE="/tmp/data"
head -1 /etc/passwd 1> ${FILE}
echo
echo ${LINE}

# Redirecting STDOUT to a file using FD 1
FILE="/tmp/data.error"
head -3 /etc/passwd /file/not/exists 2> ${FILE}
echo 


# Redirecting STDOUT and STDERR to a file using FD 1
FILE="/tmp/data.error"
head -3 /etc/passwd /file/not/exists &> ${FILE}
echo 

# discard the complete STDOUT and STDERR to dev/null (null device) , in case you dont want to print anything on console 

rm /tmp/data /tmp/data.error /tmp/uid &> /dev/null