#!/bin/bash

# This script is a demonstration of case statements in shell script:
case ${1} in
	start) echo 'Starting' ;;
	stop) echo 'Stopping' ;;
	status|state) echo 'Status:' ;;
	*)
		echo "Please supply a valid option" >&2
		exit 1
esac