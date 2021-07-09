#!/bin/bash

# Total ports in use
#echo "Total ports in use:"
#netstat -nutl | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'

# see running notes 

# Giving 4 0r 6 as arguments for filtering TCPIP v4 and V6


netstat -${1}nutl | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'