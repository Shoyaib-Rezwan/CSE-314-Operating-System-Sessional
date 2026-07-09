#!/usr/bin/bash

i=0
while ((i<5)); do
    echo $i
    ((i++))
    continue
    echo "Hello World"
done

i=0

until test $i -ge 5 ; do
    echo $i
    ((i++))
    continue
done