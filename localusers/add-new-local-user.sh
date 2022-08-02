#!/bin/bash

# Execute only with root privileges
if [[ $(id -u) -ne 0 ]]
then
    echo "You must be a root to execute this script."
    exit 1
fi

# Execute only when at least one account name is specified
NUM_PARAMS=${#}

if [[ "${NUM_PARAMS}" -eq 0 ]]
then
    echo "Usage: ./add-new-local-user.sh USER_NAME [COMMENT]"
    exit 1
fi

# Assign first parameter as user name
USER_NAME=${1}
shift

# Anything else is a comment
COMMENT="${@}"

# Generate random password for a user
# Add a special character to the password
S='!@#$%^&*()_+{}:<>?'
SHUFFLED=$(echo "${S}" | fold -w1 | shuf | head -c1)
PASSWORD="$(echo ${USER_NAME}${RANDOM}$(date +s%) | sha256sum | head -c15)${SHUFFLED}"

# add new user:
useradd -c "${COMMENT}" -m "${USER_NAME}"

# Informs the user if the account was not able to be created for some reason.
# If the account is not created, the script is to return an exit status of 1.
if [[ "${?}" -ne 0 ]]
then
    echo "User could not be created."
    userdel ${USER_NAME}
    exit 1
fi

echo ${PASSWORD} | passwd --stdin ${USER_NAME}
passwd -e ${USER_NAME}

# Displays the username, password, and host where the account was created.
# This way the help desk staff can copy the output of the script in order
# to easily deliver the information to the new account holder.
echo
echo 'User created with the following information:'
echo
echo "Username: ${USER_NAME}"
echo "Password: ${PASSWORD}"
echo "Hostname: ${HOSTNAME}"
