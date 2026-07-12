#!/usr/bin/bash
directory="photos_input"
pattern="IMG_([0-9]{8})_([0-9]{2})([0-9]{4})\.jpg$"
while IFS= read -r file; do
    target=""
    file="${file#"$directory/"}"
    if [[ "$file" =~ $pattern ]]; then
        echo "$file"
        hour="${BASH_REMATCH[2]}"
        hour=${hour#0}
        echo "$hour"
        if ((hour>=0 && hour<12)); then
            target="Morning"
        elif ((hour>=12 && hour<17)); then
            target="Afternoon"
        else
            target="Evening"
        fi
        target="$directory/$target"
        echo "$target"
        if [[ ! -d "$target" ]]; then
            mkdir -p $target
        fi
        mv "$directory/$file" "$target"
    fi
done< <(find "$directory"/* -type f 2>/dev/null)