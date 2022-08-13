#!/bin/bash

# Define a function to display error message of any kind
function error_log {
    local MESSAGE="${@}"
    echo "${MESSAGE}" >&2
    exit 1
}

# Enforces that it be executed with superuser (root) privileges.  If the script
# is not executed with superuser privileges it will not attempt to create a
# user and returns an exit status of 1.  All messages associated with this
# event will be displayed on standard error.
if [[ "${UID}" -ne "0" ]]
then
	error_log "You need to run this script with sudo or as root."
fi

# Provides a usage statement much like you would find in a man page if the user
# does not supply an account name on the command line and returns an exit status
# of 1.  All messages associated with this event will be displayed on standard
# error.

# Disables (expires/locks) accounts by default.

# Allows the user to specify the following options:

	# -d Deletes accounts instead of disabling them.

	# -r Removes the home directory associated with the account(s).

	# -a Creates an archive of the home directory associated with 
	# the accounts(s)
	# and stores the archive in the /archives directory.
	# (NOTE: /archives is not a directory that exists by default 
	# on a Linux system.  The script will need
	# to create this directory if it does not exist.)

# Any other option will cause the script to display a usage statement and exit
# with an exit status of 1.

# Let's define usage function that echos a manual like page:
function usage {
    echo
    echo "Usage: ${0} [-d] [-r] [-a] USER_NAME [USER_NAME]"
    echo
    echo 'Disable specified user(s) from the system. Disabled users cannot log in.'
    echo
    echo 'Options:'
    echo '  -d    Delete user instead of disabling.'
    echo '  -a    Create archive of user''s home directory'
    echo '  -r    Remove home directory associated with user account'
    echo
    exit 1
}

# define defaults
DISABLE_FLAG='true'
REMOVE_HOME_FLAG='false'
ARCHIVE_FLAG='false'

while getopts dra OPTION
do
	case ${OPTION} in
		d)
			# delete account instead of disabling it
			echo "User account will be deleted instead of disabling"
            DISABLE_FLAG='false'
			;;
		r)
			# remove home directory
            echo "Removing /home/${USER_NAME} - this operation cannot be undone."
			REMOVE_HOME_FLAG='true'
			;;
		a)
			# archive home directory
            echo "Archiving /home/${USER_NAME} into /var/tmp/restore/${USER_NAME}.tar.gz"
            ARCHIVE_FLAG='true'
            ;;
    esac
done

function delete_or_disable_user {
    if [[ "${DISABLE_FLAG}" = 'true' ]]
    then
        echo "Disabling user ${2} with UID ${3}"
        chage -E0 ${USER_NAME} 
    else
        echo "Deleting user ${2} with UID ${3}"
        userdel -f ${USER_NAME}
    fi
}

function archive_homedir {
    if [[ "${ARCHIVE_FLAG}" = 'true' ]]
    then
        tar -cvzf /var/tmp/restore/${USER_NAME}.tar.gz /home/${USER_NAME}
    fi
}

function remove_homedir {
    if [[ "${REMOVE_HOME_FLAG}" = 'true' ]]
    then
        rm -rf /home/${USER_NAME}
    fi
}

# Accepts a list of usernames as arguments.  At least one username is required
# or the script will display a usage statement much like you would find in a man
# page and return an exit status of 1.  All messages associated with this event
# will be displayed on standard error.

# shift to arguments passed after options:
shift $(( $OPTIND - 1))

# check if at least one username has been passed
if [[ "${#}" -eq 0 ]]
then
    usage
    exit 1
fi

for USER_NAME in "${@}"
do
# Refuses to disable or delete any accounts that have a UID less than 1,000.
    USER_ID=$(id -u $USER_NAME)
    if [[ "${USER_ID}" -lt "1000" ]]
    then
        :
    else
        delete_or_disable_user ${DISABLE_FLAG} ${USER_NAME} ${USER_ID}
        archive_homedir ${ARCHIVE_FLAG} ${USER_NAME} ${USER_ID}
        remove_homedir ${ARCHIVE_FLAG} ${USER_NAME} ${USER_ID}
    fi
done
# Only system accounts should be modified by system administrators.  Only allow
# the help desk team to change user accounts.

# Informs the user if the account was not able to be disabled, deleted, or
# archived for some reason.

# Displays the username and any actions performed against the account.

exit 0