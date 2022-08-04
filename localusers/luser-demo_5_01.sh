#!/bin/bash

# This script demonstrates the use of standard input and output

# First let's redirect stdout to file
FILE="/tmp/data"
head -n1 /etc/passwd > ${FILE}
echo "Contents of the ${FILE}"
cat ${FILE}

# Read from file into stdin
read LINE < ${FILE}
echo "Contents of LINE variable: ${LINE}"

# Redirect to file - change file content
PASSWORD=$(date +%s | sha256sum | head -c16)
echo "${PASSWORD}" > ${FILE}
echo "Contents of the ${FILE}"
cat ${FILE}


# Redirect to file - append to file
echo "xpwd-${RANDOM}$(date +%s | sha256sum | head -c16)" >> ${FILE}
echo "ypwd-${RANDOM}$(date +%s | sha256sum | head -c16)" >> ${FILE}
echo "zpwd-${RANDOM}$(date +%s | sha256sum | head -c16)" >> ${FILE}
echo "Contents of the ${FILE}"
cat ${FILE}