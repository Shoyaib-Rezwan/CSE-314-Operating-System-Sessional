#!/usr/bin/bash

while IFS= read -r line; do
    echo "$line"
done<"readme.txt"

content=$(<"readme.txt") # same as content =$(cat "readme.txt") but way more faster
# because it doesn't have the overhead of calling procedure cat
echo "$content"

mapfile lines < "readme.txt" 
echo -n "${lines[@]}"
