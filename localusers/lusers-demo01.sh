#!/bin/bash

CURRENT_USER=$(id -u)
CURRENT_USER_NAME=$(id -un)

echo "Your current UID is ${CURRENT_USER}"
echo "Your current username is ${CURRENT_USER_NAME}"

if [[ "${CURRENT_USER}" -eq "1000" ]]
then
    echo "Your UID matches 1000"
else
    echo "Your UID does not match expected value"
    exit 1
fi


