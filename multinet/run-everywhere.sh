#!/bin/bash

SERVER_FILE='/vagrant/servers'
DRY_RUN='false'
RUN_AS_SUDO=''
VERBOSE='false'

# Executes all arguments as a single command on every server listed in the /vagrant/servers file by default.
# Executes the provided command as the user executing the script.

# Uses "ssh -o ConnectTimeout=2" to connect to a host.
#  This way if a host is down, the script doesn't hang for more than 2 seconds per down server.

# Allows the user to specify the following options:

# -f FILE  This allows the user to override the default file of /vagrant/servers.
# This way they can create their own list of servers execute commands against that list.

# -n  This allows the user to perform a "dry run" where the commands will be
# displayed instead of executed.  Precede each command that would have been executed with "DRY RUN: ".

# -s Run the command with sudo (superuser) privileges on the remote servers.

# -v Enable verbose mode, which displays the name of the server for which the command is being executed on.

while getopts f:nsv OPTION
do
    case ${OPTION} in
        f)
            SERVER_FILE="${OPTARG}"
            ;;
        n)
            DRY_RUN='true'
            ;;
        s)
            RUN_AS_SUDO='sudo'
            ;;
        v)
            VERBOSE='true'
        
    esac
done

shift "$(( OPTIND - 1 ))"
COMMAND="${@}"

# Provides a usage statement much like you would find in a 
# man page if the user does not supply a command to run on the 
# command line and returns an exit status of 1.  
# All messages associated with this event will be displayed on standard error.
function usage {
    echo
    echo "Execute command specified as argument on all servers from the server definition file."
    echo
    echo "Usage: ${0} [-n] [-v] [-f server file] -[s] {command}"
    echo
    echo "Options:"
    echo
    echo "  -f    Specify a file name to use. By default if -f is not specified,"
    echo "        then /vagrant/servers file needs to be present and will be used"
    echo "  =s    Run ssh commands as superuser"
    echo "  -n    DRY RUN. The commends will be just echoed to the screen adn not executed"
    echo "  -v    Verbose mode on. Print server name where a command is being executed"

}

if [[ "${COMMAND}" = '' ]]
then
    usage
    exit 1
fi


if [[  ! -e ${SERVER_FILE} ]]
then
    echo "Server file ${SERVER_FILE} cannot be opened." >&2
    exit 1
fi

# Enforces that it be executed without superuser (root) privileges.
# If the user wants the remote commands executed with superuser (root) privileges,
# they are to specify the -s option.

if [[ "${UID}" -eq "0" && "${RUN_AS_SUDO}" -eq 'false' ]]
then
    echo "You cannot run this as root. Use -s option to run with superuser priveleges" >&2
    exit 1
fi



# Run commands on all servers
# Informs the user if the command was not able to be executed successfully on a remote host.

for SERVER in $(cat ${SERVER_FILE})
do
    if [[ "${VERBOSE}" = 'true' ]]
    then 
        echo "${SERVER}" 
    fi

    if [[ "${DRY_RUN}" = 'true' ]]
    then
        echo "DRY RUN: ssh -o ConnectTimeout=2 ${SERVER} ${RUN_AS_SUDO} ${COMMAND}"
    else
        ssh -o ConnectTimeout=2 ${SERVER} ${RUN_AS_SUDO} ${COMMAND}
        
        if [[ $? -ne 0 ]]
        then
            echo "Could not run ${COMMAND} on ${SERVER}" >&2
            exit 1
        fi
    fi
done

# Exits with an exit status of 0 or the most recent non-zero exit status of the ssh command.
exit "${?}"