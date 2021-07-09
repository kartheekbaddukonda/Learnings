#!/bin/bash

# sort      : to sort strings 
# sort -r   : to reverse sort
# sort -n   : to sort numbers
# sort -k   :  
# sort -h   : sort human readable numbers 
# sort -u   : sorts and result the unique results (removes duplicates)
# uniq      : will also removes duplicates if piped with sort (which is equevelant to sort -un) so the use of uniq after sort is 
              # that it will give number of occurances of duplicate data if appended flag -c

              
# du /<loc> : to know disk usage in KB ex: sudo du /var
#           : -h flag gives human readable format

# [vagrant@localhost vagrant]$ netstat -nutl | grep : | awk '{print $4}' | awk -F ':' '{print $NF}' | sort -un
# 22
# 25
# 68
# 323
# 37474
# 49961
# [vagrant@localhost vagrant]$ netstat -nutl | grep : | awk '{print $4}' | awk -F ':' '{print $NF}' | sort -n | uniq -c
#       2 22
#       2 25
#       1 68
#       2 323
#       1 37474
#       1 49961
# [vagrant@localhost vagrant]$ 

# wc gives the word count

# Display the top three most visited URLs for a given web server log file.

LOG_FILE="${1}"

if [[ ! -e "${LOG_FILE}" ]]
then
  echo "Cannot open ${LOG_FILE}" >&2
  exit 1
fi

cut -d '"' -f 2 ${LOG_FILE} | cut -d ' ' -f 2 | sort | uniq -c | sort -n | tail -3