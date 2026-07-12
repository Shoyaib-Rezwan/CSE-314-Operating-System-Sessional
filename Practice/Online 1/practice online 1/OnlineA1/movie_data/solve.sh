#!/usr/bin/bash

blank_count=0
while IFS= read -r file; do
    file=${file#./}
    if [[ "$file" =~ .*/.* || ! "$file" =~ .*\.txt$ ]]; then
        continue
    fi
    blank_count=0
    while IFS= read -r line; do
        if [[ -z "$line" ]]; then
            ((blank_count++))
            continue
        fi
        if ((blank_count==2)); then
            director="$line"
            mkdir "$director" 2>/dev/null
            cp "$file" "$director/$file"
            break
        fi
    done< "$file"
done< <(find ./* -type f ) 