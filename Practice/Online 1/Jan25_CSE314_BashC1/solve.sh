#!/usr/bin/bash

heist="heist"
blueprint="blueprints"
pattern="^Part_([0-9]{2})_(.+)\.dat$"
declare -A map

while IFS= read -r file; do
    directory=$(dirname "$file")
    country=${directory#"$heist"/}
    relative_path="${file#"$directory/"}"
    mkdir -p "$blueprint/$country"
    cp "$file" "$blueprint/$country/$relative_path"
    if [[ "$relative_path" =~ $pattern ]]; then
        number="${BASH_REMATCH[1]}"
        number="$((10#$number))"
        category="${BASH_REMATCH[2]}"
        if  ((number%2==0)); then
            if [[ -n "${map[$category]+x}" ]]; then
                ((map["$category"]++))
            else
                map["$category"]=1
            fi
        fi
    fi
done< <(find "$heist"/* -type f)

for category in "${!map[@]}"; do
    echo "$category: ${map["$category"]}"
done