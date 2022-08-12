#!/bin/bash

log_simple() {
    echo 'You called the log function'
}

log_with_params() {
    local MESSAGE="${@}"
    echo "${MESSAGE}"
}

log_simple
log_with_params 'Hello'
log_with_params 'This is fun'

function log_v {
    local VERBOSE="${1}"
    shift
    local MESSAGE="${@}"
    if [[ "${VERBOSE}" = 'true' ]]
    then
        echo "${MESSAGE}"
    fi
}

VERBOSITY='true'
log_v "${VERBOSITY}" "Hello World"
log_v "${VERBOSITY}" "This is real fun!"

# Function to send message to system log and if verbosity is enabled
# the message is also displayed on the standard output (screen).
log() {
    local VERBOSE="${1}"
    shift
    local MESSAGE="${@}"
    if [[ "${VERBOSE}" = 'true' ]]
    then
        echo "${MESSAGE}"
    fi

    logger -t "luser-demo_6_02.sh" "${MESSAGE}"
}

log "${VERBOSITY}" "This is a test message" # will also show on screen
VERBOSITY='false'
log "false" "This is a test message without stdout" # will not show on screen
VERBOSITY='true'

# Backup file into /var/tmp and append message to syslog
backup_file() {
    local FILE="${1}"
    # Make sure the file exists
    if [[ -f "${FILE}" ]]
    then
        local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
        log "${VERBOSITY}" "Backing up ${FILE} to ${BACKUP_FILE}"
        cp -p "${FILE}" "${BACKUP_FILE}"
    else
        echo "File ${FILE} does not exist" >&2
        return 1
    fi
}

backup_file "/etc/passwd"