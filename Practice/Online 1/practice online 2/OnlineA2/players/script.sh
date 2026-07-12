#!/usr/bin/bash

set -euo pipefail
while IFS= read -r file; do
    file=${file#./}
    if [[ ! "$file" =~ .*\.txt$ ]]; then
        continue
    fi
    player_name="#"
    country="#"
    role="#"
    while IFS= read -r line; do
        if [[ -z "$line" ]]; then
            continue
        fi
        if [[ "$player_name" == "#" ]]; then
            player_name="$line"
            continue
        fi
        if [[ "$country" == "#" ]]; then
            country="$line"
            continue
        fi
        if [[ "$role" == "#" ]]; then
            role="$line"
            break
        fi
        
    done< "$file"
    directory="$country/$role"
    mkdir -p "$directory"
    if [[ "$file" != "$directory/$player_name.txt" ]]; then
        mv "$file" "$directory/$player_name.txt"
    fi
done< <(find ./* -type f 2>/dev/null)

while IFS= read -r dir; do
    echo "$dir"
    if [[ -z $(find "$dir"/* -type f) ]]; then
        rm -rf "$dir"
    fi
done< <(find ./* -type d 2>/dev/null)