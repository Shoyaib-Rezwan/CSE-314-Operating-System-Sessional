#!/usr/bin/bash

pattern1="^(.+)\ \([0-9]{4}\)\ -\ (.+)\.(mp3|mp4|mkv|flac)"
pattern2="^(.+)\ -\ (.+)\.(mp3|mp4|mkv|flac)"
declare -A catalog
while IFS= read -r file; do
    file=${file#media/}
    if [[ "$file" =~ $pattern1 ]]; then
        title=${BASH_REMATCH[1]}
        artist=${BASH_REMATCH[2]}
    elif [[ "$file" =~ $pattern2 ]]; then
        artist=${BASH_REMATCH[1]}
        title=${BASH_REMATCH[2]}
    else
        artist=unknown
        title=unknown
        continue
    fi
    if [[ -n "${catalog[$artist]}" ]]; then
        catalog["$artist"]+=$(echo -e "\n$title")
    else
        catalog["$artist"]="$title"
    fi
    
done< <(find "media/"* -type f)

true > output.txt
while IFS= read -r artist; do
    echo "$artist" >> output.txt
    printf "%s\n" "${catalog[$artist]}" | sort |sed 's/^/\t/' >> output.txt
done< <(printf "%s\n" "${!catalog[@]}" | sort 2>/dev/null)
