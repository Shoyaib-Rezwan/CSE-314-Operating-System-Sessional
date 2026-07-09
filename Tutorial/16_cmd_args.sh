#!/usr/bin/bash

echo "The script name is: $0"
echo "The first argument is: ${1}"
echo "The second argument is: ${2:-default2}" # parameter expansion. If there is no 2nd argument passed to it then default2 will be printed

echo "All arguments: ${*}"
echo "The total number of argument passed is: $#"