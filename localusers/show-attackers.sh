#!/bin/bash

INPUT_FILE="${1}"

if [[ ! -e "${INPUT_FILE}" ]]
then
    echo "You need to provide input file!" >&2
    exit 1
fi

# parse the syslog to get list of IPs
# redirect to /dev/null as this is just for illustration
# part of this script logis is used to get IP_LIST and use
# geoiplookup to determine country where the traffic is inbound from
grep 'Failed' ${INPUT_FILE} | cut -d ':' -f 4 | awk -F ' ' '{print $(NF-3)}' | sort | uniq -c | sort -nr >& /dev/null

# determine list of unique IPs
grep 'Failed' ${INPUT_FILE} | cut -d ':' -f 4 | awk -F ' ' '{print $(NF-3)}' | sort | uniq -c | sort -nr | while read COUNT IP
do
    if [[ "${COUNT}" -gt "10" ]]
    then
        echo "${COUNT},${IP},$(geoiplookup ${IP})"
    fi
done

exit 0
