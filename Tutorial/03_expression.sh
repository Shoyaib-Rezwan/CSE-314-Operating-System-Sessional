#!/usr/bin/bash

expr 7 + 2 # The spaces are mandatory
expr 7 - 2 
expr 7 / 2 #Floor division
expr 7 \* 2  # * indicates files of current directory

n=$(expr 7 + 2)

echo $n

n=$((7 * 2)) # notice * doesn't need \ 

echo $n

((n=7 * 2))

echo $n

