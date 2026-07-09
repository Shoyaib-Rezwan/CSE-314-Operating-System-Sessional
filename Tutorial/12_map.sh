#!/usr/bin/bash
declare -A capital=(
[Bangladesh]=Dhaka
[India]=NewDelhi
[Pakistan]=Istanbul
)
echo "keys= ${!capital[*]}"
echo "values= ${capital[*]}"

if [[ ! -v capital[France] ]]; then
    echo "France is not in the assosiative array"
    capital[France]=Paris
    echo "${capital[France]}"
fi

unset "capital[India]"

echo "keys= ${!capital[*]}"
echo "values= ${capital[*]}"