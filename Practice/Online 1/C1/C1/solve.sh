#!/usr/bin/bash

input_dir="input_dir"
output_dir="output_dir"
while IFS= read -r file; do
    relative_path="${file#"$(dirname "$file")/"}"
    mode=$(ls -la "$file" | cut -d ' ' -f 1)
    if [[ ! $mode =~ .*x.* ]]; then
        continue
    fi
    month=$(date "+%b" -d @"$(stat -c "%Y" "$file")")
    mkdir -p "$output_dir/$month"
    cp "$file" "$output_dir/$month/$relative_path"
    chmod -x "$output_dir/$month/$relative_path"
done< <(find "$input_dir" -type f)