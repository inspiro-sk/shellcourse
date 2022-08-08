#!/bin/bash

# Demonstrate the use of shift and while loop

# infinite loos
while [[ "${#}" -gt 0 ]]
do
    echo "Number of parameters: ${#}"
    echo "Paremeter 1: ${1}"
    echo "Paremeter 2: ${2}"
    echo "Paremeter 3: ${3}"
    echo 
    shift
done