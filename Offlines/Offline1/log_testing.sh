#!/bin/bash

shopt -s expand_aliases

alias bvcs='"/home/shoyaib/Storage/Drive1/shoyaib/BUET/Level3 Term1/Course Materials/Sessional/CSE 314/Offlines/Offline1/2205014.sh"'

if [[ -d tmp/bvcs_task5 ]]; then
    rm -rf tmp/bvcs_task5
fi
mkdir tmp/bvcs_task5 && cd tmp/bvcs_task5 || exit
bvcs init
bvcs log
echo "hello" > greet.txt && echo "world" > world.txt
bvcs add greet.txt world.txt
bvcs commit -m "Initial commit"
bvcs add world.txt && bvcs commit -m "Second commit"
bvcs log
