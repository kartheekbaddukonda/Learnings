#!/bin/bash

# standard input  :      comes from keyboard or pipe   (FD 0) - file descriptor
# standard output :      displayed on screen           (FD 1) - file descriptor
# standard error  :      displayed on screen           (FD 2) - file descriptor


# This is implicit way of STDOUT to file here 1 is assumed

echo ${UID} > /tmp/uid # This is implicit way of STDOUT to file here 1 is assumed
cat /tmp/uid

 # This is explicit way of STDOUT to file here 1 is passed
echo ${UID} 1> /tmp/uid
cat /tmp/uid
echo
echo "*******************************************"
echo

# This is implicit way of STDIN to file here 0 is assumed

read LINE < /tmp/data
cat ${LINE}

 # This is explicit way of STDIN to file here 0 is passed
read FILE 0< /tmp/data
cat ${FILE}

# head -n1 /etc/passwd /etc/hosts /fake_file > head.both 
# the bove command execute and push standard output to head.both but error will be shown in console
# to have error also pushed to the same file use 
# head -n1 /etc/passwd /etc/hosts /fake_file > head.both 2>&1

# other and most common way to redirect both standard input and standard out put is 
#head -n1 /etc/passwd /etc/hosts /fake_file &> head.both 
