#!/bin/bash
# Hello from main OS
echo 'Hello'
#assign a value to a variable 
WORD='Script'
echo "$WORD"
echo '$WORD'
echo "This is a shell $WORD"
echo "This is a shell ${WORD}"
# Append text to a variable
echo "${WORD}ing is fun"
# this doesnt expan and displays nothing
echo "$WORDing is fun"
#another variable 
ENDING='ed' 
echo "${WORD}${ENDING}"
# Reassignment
ENDING='ing' 
echo "$WORD$ENDING is fun"  #another way of echoing multiple variables