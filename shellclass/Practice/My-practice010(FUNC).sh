# Functions
# DRY - Dont repeat yourself
# WET - Waste everyones Time / We enjoy typing 

#!/bin/bash

# log()
# {
#     echo "Everytime log function called this message displays"
# }

# log
# ------------------

# log()
# {
#     local MESSAGE="${@}"
#     echo "${MESSAGE}"
# }

# log 'Hello! there'
# log 'IBMer'

# ------------------

# log() {
#     local MESSAGE="${@}"
#     if [[ ${VERBOSE} = true ]]
#     then 
#         echo "${MESSAGE}"
#     fi
# }

# log 'Hello! there'
# VERBOSE='true'
# log 'IBMer'


# ------------------

log() {
    local MESSAGE="${@}"
    if [[ ${VERBOSE} = true ]]
    then 
        echo "${MESSAGE}"
    fi
    # logger -t $(basename ${0}) ${MESSAGE}  # everytime it creates an entry in central log -  sudo tail /var/log/messages (to see last 10 entries)
    logger -t My-practice010.sh ${MESSAGE}
}


backup_file() {
    local FILE=${1}
    if [[ -f ${FILE} ]]
    then 
        local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
        # files in /var/tmp can survive reboot where as /tmp will loose after 10 days / reboot  
        log "Backing up ${FILE} to ${BACKUP_FILE}"
        cp -p ${FILE} ${BACKUP_FILE} #-p preserves the mod permissions and original timestamp even after copy 
        # gotcha, the exit status of the function is the exit status of last command it executed in the function
    else
        return 1
        # it is super important to use return inside function not exit 
    fi
    # you can call a function with in another function
}

readonly VERBOSE='true'
backup_file /etc/notexist

