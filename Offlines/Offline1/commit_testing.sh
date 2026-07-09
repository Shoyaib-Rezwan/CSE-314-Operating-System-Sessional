#!/bin/bash

shopt -s expand_aliases

alias bvcs='"/home/shoyaib/Storage/Drive1/shoyaib/BUET/Level3 Term1/Course Materials/Sessional/CSE 314/Offlines/Offline1/2205014.sh"'

mkdir -p tmp/bvcs_task4 && cd tmp/bvcs_task4 || exit 
bvcs init
echo "hello" > greet.txt && echo "world" > world.txt
bvcs add greet.txt world.txt
bvcs commit
bvcs commit -m "Initial commit"
cat .bvcs/HEAD
cat .bvcs/log
cat .bvcs/staging
ls .bvcs/objects/0001/files/
bvcs status
echo "updated" >> greet.txt
bvcs status
bvcs commit -m "empty"