#!/bin/bash

# Disaplya the first 3 parameters
echo "First parameter passed to script as argument is: ${1}"
echo "second parameter passed to script as argument is: ${2} "
echo "Third parameter passed to script as argument is: ${3}"
echo

#script call :  ./Myluser-demo07.sh kb sb nb jb
#output: 
#First parameter passed to script as argument is: sb  
#second parameter passed to script as argument is: nb 
#Third parameter passed to script as argument is: jb 
#note that shift applied to default 1 position , we can specify shift [2 ...] to skip those many positions 

# Loop through all positional parameters 

#while [[ "${#}" -gt 0 ]]
#do
#    echo "numer of parameters passed are ${#}"
#    echo "Parameter 1: ${1}"
#    echo "Parameter 2: ${2}"
#    echo "Parameter 3: ${3}"
#    echo 
#    shift
#done

# use case for shift : usage ./Myluser-demo07.sh kb Kartheek baddukonda
# result: 
#User name is  kb
#Full name: Kartheek baddukonda
# Notice positional parameter * usage and shift usage

echo "User name is: ${1}"
shift
echo "Full name: ${*}"
echo 




