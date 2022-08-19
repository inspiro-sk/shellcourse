#!/bin/bash
#
# This script pings a list of servers

SERVER_FILE='/vagrant/servers'

if [[ ! -e ${SERVER_FILE} ]]
then
    echo "Cannot open ${SERVER_FILE}" >&2
    exit1
fi

for SERVER in $(cat ${SERVER_FILE})
do
    echo "Pinging ${SERVER}"
    ping -c 1 ${SERVER} &> /dev/null
    if [[ "${?}" -ne 0 ]]
    then
        echo "${SERVER} is unreachable"
    else
        echo "${SERVER} up and running"
    fi
done    
