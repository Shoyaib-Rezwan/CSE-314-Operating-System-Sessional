#!/usr/bin/bash
directory="$1"
if [[ -z "$2" ]]; then
    cache_path="cache2.txt"
else
    cache_path="$2"
fi
report="$report.txt"
echo -n "Scan time: "
date +"%Y-%m-%d %H:%M:%S"
# echo "Directory: $directory" 
echo -e "\nBROKEN LINK COUNTS:"

pattern=".+\.html$"
pattern2="<a href=\"(.+)\">"
while IFS= read -r file; do
    file_dir=$(dirname "$file")
    if [[ ! "$file" =~ $pattern ]]; then
        continue
    fi
    (cd "$file_dir" || exit
    count=0
    while IFS= read -r link ; do
        if [[ "$link" =~ $pattern2 ]]; then
            link="${BASH_REMATCH[1]}"
            if ! find "$file_dir" -path "*$link" | grep -q .; then
                ((count++))
            fi
        fi
    done< "$file"
    echo "$file: $count")
done< <(find docs/* -type f)
