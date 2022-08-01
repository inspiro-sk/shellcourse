#!/bin/bash

# This script creates a user on the system
# You will be prompted for a username and password

read -p "Enter your username for the account: " USER_NAME
read -p "Enter your first and last name: " USER_REAL_NAME
read -p "Enter account password: " PASSWORD

# create the actual user
useradd -c "${USER_REAL_NAME}" -m ${USER_NAME}

# Set user password
echo ${PASSWORD} | passwd --stdin ${USER_NAME}
passwd -e ${USER_NAME}
