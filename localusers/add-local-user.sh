#!/bin/bash


# Enforces that it be executed with superuser (root) privileges.
# If the script is not executed with superuser privileges it will not
# attempt to create a user and returns an exit status of 1.
CURRENT_USER=$(id -u)

if [[ "${CURRENT_USER}" -ne 0 ]]
then
    echo "You are not a root user, aborting script!"
    exit 1
fi

# Prompts the person who executed the script to enter the username (login),
# the name for person who will be using the account, and the initial password
# for the account.
read -p "Enter username for new account: " USER_NAME
read -p "Enter real name for the user: " REAL_NAME
read -p "Enter initial user password: " PASSWORD

# Creates a new user on the local system with the input provided by the user.
useradd -c "${REAL_NAME}" -m ${USER_NAME}

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
