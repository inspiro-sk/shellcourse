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

# Redirect STDIN to a program using FD0
read LINE 0< ${FILE}
echo
echo "LINE contains ${LINE}"

# Redirect STDOUT to a file using FD 1 overwriting the file
head -n3 /etc/passwd 1> ${FILE}
echo
echo "Contents of the ${FILE}"
cat ${FILE}

# Redirect STDERR to a file using FD 2
ERR_FILE="/tmp/data.err"
head -n3  /etc/passwd /fakefile 2> ${ERR_FILE}
echo
echo "Contents of the ${ERR_FILE}"
cat ${ERR_FILE}

# Redirect STDOUT and STDERR to a file
echo
head -n3  /etc/passwd /fakefile &> ${FILE}
echo "Contents of the ${FILE}"
cat ${FILE}

# Redirect STDOUT and STDERR through a pipe
echo
head -n3  /etc/passwd /fakefile |& cat -n

# Send output to standard error
echo
echo "This is STDERR" >&2

# In case a script needs to be executed, but user should not see the output, then
# output can be redirected to /dev/null
# To determine status we can check exit code using echo ${?}
head -n3  /etc/passwd /fakefile &> /dev/null
echo "Last command status code: ${?} / Expected: !0"

head -n3  /etc/passwd &> /dev/null
echo "Last command status code: ${?} / Expected: 0"

# Cleanup:
rm ${FILE} ${ERR_FILE} &> /dev/null