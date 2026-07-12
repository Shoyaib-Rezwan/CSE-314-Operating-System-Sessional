#!/usr/bin/bash
declare -A map
min_page="$1"
new_dir="output"
mkdir "$new_dir"
while IFS= read -r file; do
    file=${file#./}
    if [[ ! "$file" =~ .*\.pdf ]]; then
        continue
    fi
    page=$(pdfinfo "$file" | grep "Pages" | awk '{print $2}')
    if [[ $min_page -gt $page ]]; then
        continue
    fi
    size=$(stat -c %s "$file")
    map["$size"]="$file"
done<  <(find ./ -type f)

count=0
while IFS= read -r size; do
    file="${map["$size"]}"
    # dir=$(dirname "$file")
    relative_path="$count"
    ((count++))
    cp "$file" "$new_dir/$relative_path"
done< <(printf "%s\n" "${!map[@]}" | sort) 