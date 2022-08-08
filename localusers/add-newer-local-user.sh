#!/bin/bash

# Enforces that it be executed with superuser (root) privileges.
# If the script is not executed with superuser privileges it will 
# not attempt to create a user and returns an exit status of 1.  
# All messages associated with this event will be displayed on standard error.
USER_ID=$(id -u)
if [[ "${USER_ID}" -ne 0 ]]; then
	echo "You must run this script as root" >&2
	exit 1
fi

# Provides a usage statement much like you would find in a man page 
# if the user does not supply an account name on the command line 
# and returns an exit status of 1.  
# All messages associated with this event will be displayed on standard error.
NUM_ARGS=${#}
if [[ "${NUM_ARGS}" -eq 0 ]]; then
	echo "Usage: ./add-newer-local-user USER_NAME [COMMENT]" >&2
	exit 1
fi

# Uses the first argument provided on the command line as the username for the account. 
# Any remaining arguments on the command line will be treated as the comment for the account.
USER_NAME="${1}"
shift
COMMENT="${@}"

# Automatically generates a password for the new account.
S='!@#$%^&*()_+{}:<>?'
SHUFFLED=$(echo "${S}" | fold -w1 | shuf | head -c1)
PASSWORD="$(echo ${USER_NAME}${RANDOM}$(date +s%) | sha256sum | head -c15)${SHUFFLED}"

# Informs the user if the account was not able to be created for some reason.
# If the account is not created, the script is to return an exit status of 1.
# All messages associated with this event will be displayed on standard error.
useradd -c "${COMMENT}" -m "${USER_NAME}" &> /dev/null

if [[ "${?}" -ne 0 ]]; then
	echo "Could not add user ${USER_NAME}" >&2
	exit 1
fi

echo "${PASSWORD}" | passwd --stdin ${USER_NAME} &> /dev/null

# Displays the username, password, and host where the account was created.
# This way the help desk staff can copy the output of the script in order to 
# easily deliver the information to the new account holder.
echo
echo 'User created with the following information:'
echo
echo "Username: ${USER_NAME}"
echo "Password: ${PASSWORD}"
echo "Hostname: ${HOSTNAME}"

# Suppress the output from all other commands.
exit 0