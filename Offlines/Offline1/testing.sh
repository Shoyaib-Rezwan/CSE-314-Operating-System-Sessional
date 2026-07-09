#!/usr/bin/bash

if [[ -d practice ]]; then
    rm -r practice
fi

shopt -s expand_aliases    # by default bash doesn't expand aliases inside scrirts.
# so, you must set the property to expand the aliases inside scripts
#shopt shell options, -s --> set, expand_aliases --> flag

alias bvcs='"/home/shoyaib/Storage/Drive1/shoyaib/BUET/Level3 Term1/Course Materials/Sessional/CSE 314/Offlines/Offline1/2205014.sh"'

mkdir practice

cd practice || exit 1

bvcs init

bvcs init

bvcs add main.c util.h

bvcs add

bvcs add main.c

bvcs add main.c utility.h

touch main.c utility.h a.cpp b.java c.py

bvcs add utility.h

bvcs add a.cpp

bvcs add main.cpp a.cpp b.java c.py

bvcs status

mkdir -p .bvcs/objects/0001/files

cp main.c .bvcs/objects/0001/files/main.c

echo "0001">.bvcs/HEAD

bvcs status

rm main.c

bvcs status

touch main.c

echo "#include<stdio.h>printf("Hello world");">main.c

bvcs status

rm -f a.cpp b.java c.py utility.h

rm main.c .bvcs/staging
touch main.c .bvcs/staging

bvcs status