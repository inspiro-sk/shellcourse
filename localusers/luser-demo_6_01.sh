#!/bin/bash

<<<<<<< HEAD
# Demonstrates the usage of command line arguments (parsing)
# Includes case statements and functions


# not ideal way to handle the specific use case:
# if [[ "${1}" = "start" ]]
# then 
#     echo "Starting"
# elif [[ "${1}" = "stop" ]]
# then 
#     echo "Stopping"
# elif [[ "${1}" = "status" ]]
# then
#     echo "Status"
# else
#     echo "Error" >&2
#     exit 1
# fi

case "${1}" in
    start) echo "Starting" ;;
    stop) echo "Stopping" ;;
    status|state) # matches status or state
        echo "Status"
        ;;
    *)
        echo "Supply a valid option!" >&2
        exit 1
        ;;
=======
# This script is a demonstration of case statements in shell script:
case ${1} in
	start) echo 'Starting' ;;
	stop) echo 'Stopping' ;;
	status|state) echo 'Status:' ;;
	*)
		echo "Please supply a valid option" >&2
		exit 1
>>>>>>> c441a92b9ca58b48f68cdf3b3dcd1fff47d3dd42
esac