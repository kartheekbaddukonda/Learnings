#!/bin/bash

# Display what user last executed on the CLI

echo "USer last executed this command: ${0}"

# Display the path and filename of the script

echo "You executed file $(basename ${0}) which is under path $(dirname ${0}) "

# Tell the user how many arguments they passed in.
# (Inside the scrpit they are parameters but outside they are arguments)
# enclosed in " " becomes a single argument irrespective its more than one"

echo "You executed file $(basename ${0}) which is under path $(dirname ${0}) with number of arguments as : ${#} "

# Make sure they atleast supplied one argument

if [[ ${#} -lt 1 ]]
then 
    echo "This script need atleast 1 argument"
    exit 1
fi

# generate and display password for each paramenter

for i in "${*}"
do
    PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c32)
    SPECIAL_CHARACTER=$(echo '~!@#$%^&*()_+' | fold -w1 | shuf | head -c1)
    NEW_PASSWORD=${PASSWORD}${SPECIAL_CHARACTER}
    echo "new Password for ${i}: ${NEW_PASSWORD}"
done

