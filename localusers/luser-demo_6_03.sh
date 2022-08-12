#!/bin/bash

# Parsing command line options using getopts
# We will create a script to generate a random password
# User can specify -l option to determine length and a use
# of special character with -s option
# User can also control level of verbosity of messages
# that are goind to be displayed on screen

function usage {
	echo
	echo "Usage: ${0} [-vs] [-l LENGTH]" >&2
	echo
	echo "Generate a random password"
	echo "  -l LENGTH  Specify the password length."
	echo "  -s         Append a special caharacter to the password."
	echo "  -v         Increase verbosity"
	echo
	exit 1
}

function send_to_stdout {
	local MESSAGE="${@}"

	if [[ "${VERBOSE}" = 'true' ]]
	then
		echo "${MESSAGE}"
	fi
}

# default password length
LENGTH=48

while getopts vl:s OPTION # -l is mandatory in this case
do
	case ${OPTION} in
		v)
			VERBOSE='true'
			echo 'Verbose mode on.'
			;;
		l)
			LENGTH="${OPTARG}"
			;;
		s)
			USE_SPECIAL_CHAR='true'
			;;
		?)
			usage
			;;
	esac
done

# print all arguments we've passed in
echo "Number of arguments: ${#}"
echo "All arguments: ${@}"
echo "First argument: ${1}"
echo "Second argument: ${2}"
echo "Third argument: ${3}"

# Inspect OPTIND
# OPTIND stores the position of next command line arg following the options
echo "OPTIND: ${OPTIND}"

# Remove the options while leaving remaining arguments
shift "$(( OPTIND - 1 ))"
echo "After the shift: "
echo "Number of arguments: ${#}"
echo "All arguments: ${@}"
echo "First argument: ${1}"
echo "Second argument: ${2}"
echo "Third argument: ${3}"	

# in this case we consider extra arguments an error so:
if [[ "${#}" -gt 0 ]]
then
	usage
fi

send_to_stdout 'Generating a password...'

PASSWORD=$(date +%s%N${RANDOM} | sha256sum | head -c${LENGTH})

if [[ "${USE_SPECIAL_CHAR}" = 'true' ]]
then
	send_to_stdout "Setting password special character"
	SPECIAL="!@#$%^&*()_+<>?"
	S=$(echo "${SPECIAL}" | fold -w1 | shuf | head -c1)
	LENGTH=$(( LENGTH-- )) # decrement by 1
	PASSWORD=$(echo ${PASSWORD} | head -c${LENGTH})${S}
fi

send_to_stdout "Password created successfully."
send_to_stdout "Your password: ${PASSWORD}"

exit 0