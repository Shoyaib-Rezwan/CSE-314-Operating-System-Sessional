#!/usr/bin/bash
 target_directory="$1"
 report="report2.txt"
true > "$report"
 scanned=0
 duplicates=0
 space=0
 declare -A map
 while IFS= read -r file; do
    ((scanned++))
    file_size=$(stat -c%s "$file")
    if [[ -n "${map[$file_size]}" ]]; then
        map[$file_size]+=$(echo -e "\n$file")
    else
        map[$file_size]=$file
    fi
 done< <(find "$target_directory"/* -type f)

for file_size in "${!map[@]}"; do
    while IFS= read -r file1 ; do
        while IFS= read -r file2 ; do
            if [[ ! -f "$file1" || ! -f "$file2" || "$file1" == "$file2" ]]; then
                continue
            fi
            hash1=$(md5sum "$file1" | cut -d ' ' -f 1)
            hash2=$(md5sum "$file2" | cut -d ' ' -f 1)
            if [[ "$hash1" == "$hash2" ]]; then
                ((duplicates++))
                space=$((space+"$file_size"))
                rm -f "$file2"
            fi
        done< <(printf "%s\n" "${map["$file_size"]}")
    done< <(printf "%s\n" "${map["$file_size"]}")
done

echo "Total files scanned: $scanned" >> "$report"
echo "Duplicates found: $duplicates" >> "$report"
echo "Space saved: $space bytes" >> "$report"