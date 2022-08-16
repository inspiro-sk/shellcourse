#!/bin/bash

INPUT_FILE="${1}"

if [[ ! -e "${INPUT_FILE}" ]]
then
    echo "You need to provide input file!" >&2
    exit 1
fi

# parse the syslog to get list of IPs
grep 'Failed' ${INPUT_FILE} | cut -d ':' -f 4 | awk -F ' ' '{print $(NF-3)}' | sort | uniq -c | sort -nr