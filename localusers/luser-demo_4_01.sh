#!/bin/bash

# Generate a random number as password
PASSWORD=${RANDOM}${RANDOM}${RANDOM}
echo "Three random numbers together: ${PASSWORD}"

# use epoch as password:
PASSWORD=$(date +%s)
echo "Use epoch as password: ${PASSWORD}"

# Generate even harder password:
# can use %N in format as this can add nanoseconds information to date

# or event better:
# hash epoch and use 16 characters of the has as password
PASSWORD=$(date +%s | sha256sum | head -c 16)
echo "Use hashed epoch and only first 16 characters: ${PASSWORD}"

# Add a special character to the password
S='!@#$%^&*()_+{}:<>?'

# put each character on separate line, shuffle and take first line
SHUFFLED=$(echo "${S}" | fold -w1 | shuf | head -c1)
echo "Use hashed epoch, first 16 chars and add special character: ${PASSWORD}${SHUFFLED}"
