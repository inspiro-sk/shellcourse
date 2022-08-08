#!/bin/bash

# This script demonstrates functions and parsing command line options
# First we will create a function that writes to /var/log/messages

function log {
	if [[ "${#}" -gt "1" ]]
	then
		local VERBOSE="${1}"
		shift
	else
		local VERBOSE='true'
	fi

	local MESSAGE="${@}"

	if [[ "${VERBOSE}" = 'true' ]]
	then
		echo "${MESSAGE}"
	fi

	logger -t 'luser-demo_6_02.sh' "${MESSAGE}"
}

log 'false' "Only logging to /var/log/messages"
log 'true' "Logging on screen as well"
log "By default we are outputing to screen as well"

function backup_file {
	local FILE=${1}

	# Backup in case file exists
	if [[ -f "${FILE}" ]]
	then
		BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
		log "Backing up ${FILE} to ${BACKUP_FILE}"

		cp -p "${FILE}" "${BACKUP_FILE}"
	else
		log "File ${FILE} does not exist. No backup created."
		return 1 # we just want to exit function not script (exit will jump out of entire script)
	fi
}

backup_file "/etc/passwd"
backup_file "/etc/hosts"
backup_file "etc/fakefile"