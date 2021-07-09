#!/bin/bash

# Using if 

# if [[ ${1} = "start" ]]
# then
#     echo 'Starting'
# elif [[ ${1} = 'stop' ]]
# then
#     echo "Stopping"
# elif [[ ${1} = 'status' ]]
# then
#     echo "Status"
# else 
#     echo "Supply valid Option" 
#     exit 1
# fi

# USing case 

case ${1} in 
  start)
    echo "Starting"
    ;;
  stop)
    echo "Stopping"
    ;;
  status | state)
    echo "Status"
    ;;
  *)
    echo "Please choose valid option"  >&2 
    exit 1
    ;;
esac







