#!/usr/bin/bash
size=0
declare -A array
for((i=0;i<10;i++)); do
    array["$i"]="Hello"
done

while a in "${!array[@]}"; do
    echo "$a"
done