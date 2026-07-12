#!/usr/bin/bash

pattern1="^(.+)\ \([0-9]{4}\)\ -\ (.+)\.(mp3|mkv|mp4|flac)"
pattern2="^(.+)\ -\ (.+)\.(mp3|mkv|mp4|flac)"
declare -A map
while IFS= read -r file; do
    file="${file#media/}"
    if [[ "$file" =~ $pattern1 ]]; then
        title="${BASH_REMATCH[1]}"
        artist="${BASH_REMATCH[2]}"
    elif [[ "$file" =~ $pattern2 ]]; then
        artist="${BASH_REMATCH[1]}"
        title="${BASH_REMATCH[2]}"
    fi
    if [[ -z "$artist" ]]; then
        continue
    fi
    if [[ -n "${map[$artist]+x}" ]]; then
        map[$artist]+=$(echo -e "\n$title")
    else
        map[$artist]="$title"
    fi
done< <(find media/* -type f)

while IFS= read -r artist; do
    echo "$artist"
    echo "${map[$artist]}" | sort | sed 's|^|\t|'
done< <(printf "%s\n" "${!map[@]}" | sort )