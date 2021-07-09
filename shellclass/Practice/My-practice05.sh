#!/bin/bash

# A random number as a password
PASSWORD=${RANDOM}  #RANDOM is bash in built 
echo "${PASSWORD}"

# A random number as a password
PASSWORD=${RANDOM}${RANDOM}${RANDOM}  
echo "${PASSWORD}"

# Date as random password
PASSWORD=$(date +%s%N | sha256sum)  #date is a bash inbuilt and we can format them %s with seconds and %N with nano seconds, refer notes for sha 
echo "${PASSWORD}"

# A better one 
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c32) 
echo "${PASSWORD}"

# Apend a special characted to the password
SPECIAL_CHARACTER=$(echo '~!@#$%^&*()_+' | fold -w1 | shuf | head -c1)
NEW_PASSWORD=${PASSWORD}${SPECIAL_CHARACTER}
echo "${NEW_PASSWORD}"
 

