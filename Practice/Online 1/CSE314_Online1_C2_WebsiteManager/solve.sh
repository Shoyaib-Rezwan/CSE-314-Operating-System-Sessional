#!/usr/bin/bash
web_directory="$1"

while IFS= read -r file; do
    file="${file#"$web_directory/"}"
    if [[ "$file" =~ .+\.(html|htm)$ ]] ; then
        dir_name=$(dirname "$file")
        mkdir -p "deploy/$dir_name"
        cp "$web_directory/$file" "deploy/$file"
    fi
    if [[ "$file" =~ .+\.(css)$ ]] ; then
        dir_name=$(dirname "$file")
        mkdir -p "deploy/assets/css/$dir_name"
        cp "$web_directory/$file" "deploy/assets/css/$file"
    fi
    if [[ "$file" =~ .+\.(js)$ ]] ; then
        dir_name=$(dirname "$file")
        mkdir -p "deploy/assets/js/$dir_name"
        cp "$web_directory/$file" "deploy/assets/js/$file"
    fi
    if [[ "$file" =~ .+\.(jpg|png|gif|svg)$ ]] ; then
        dir_name=$(dirname "$file")
        mkdir -p "deploy/assets/images/$dir_name"
        cp "$web_directory/$file" "deploy/assets/images/$file"
    fi
done< <(find "$web_directory/"* 2>/dev/null)

while IFS= read -r file; do
    if [[ "$file" =~ .+\.(html|htm)$ ]] ; then
        sed -i 's|<link rel="stylesheet" href="\(.*\)styles/\(.*\)\.css">|<link rel="stylesheet" href="assets/css/\1\2.css">|' "$file"
    fi
done< <(find deploy/* -type f 2>/dev/null)