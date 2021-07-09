#!/bin/bash
#  getopts or getopt

# The user can set the password length with -l and add a special character with -s option and 
# verbose mode can be enabled with -v option

log() {
    local MESSAGE="${@}"
    if [[ ${VERBOSE} = true ]]
    then 
        echo "${MESSAGE}"
    fi
}

usage() {

    echo "The script can only take -v, -l , -s as command line optional arguments"
    echo " when used -l make sure appropriate length also passed"
}

LENGTH=48
while getopts vl:s OPT #if the option is followed by colon, it is expected to have argument which should be seperated by whitespace 
do
  case ${OPT} in
    v)
       VERBOSE='true'
       log "Verbose mode is ON"
       ;;
    l)
       LENGTH="${OPTARG}"
       ;;
    s)
      USE_SPECIAL_CHARACTER='true'
      ;;
    ?)
      usage
      ;;
  esac
done

log "Generating Password"
PASSWORD=$(date +%s%N | sha256sum | head -c${LENGTH}) 

if [[ ${USE_SPECIAL_CHARACTER} = true ]]
then 
    PICK_SC=$(echo '!@#$%^&*()_+=' | fold -w1 | shuf | head -c1)
    PASSWORD=${PASSWORD}${PICK_SC}
fi

echo ${PASSWORD}


