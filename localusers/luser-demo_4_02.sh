#!/bin/bash

# This script generates random password for each user specified on command line

# Display what the user typed in the command line
# ${0} will be the name of the script in this case

echo "You executed the following command: ${0}"

echo "You used $(dirname ${0}) as path to $(basename ${0})"

NUM_ARGUMENTS=${#}
echo "Number of usernames passed in command line was ${NUM_ARGUMENTS}"

# Make sure there are arguments in the command line

if [[ "${#}" -lt 1 ]]
then
    echo "Usage: ${0} USER_NAME [USER_NAME]"
    exit 1
fi

echo "Usernames: ${@}"

# Process arguments from command line:
for USER_NAME in "${@}"
do
    # generate password:
    PASSWORD=$(echo "${RAND}${USER_NAME}$(date +%s)" | sha256sum | head -c16)
    echo "Username: ${USER_NAME} Password: ${PASSWORD}"
done
