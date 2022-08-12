#!/bin/bash

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
esac