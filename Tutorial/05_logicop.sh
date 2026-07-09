#!/usr/bin/bash

true && false # both will execute
echo $?

false || true
echo $?

true || false # only true will execute
echo $?

false && true
echo $?

echo "bash" && echo "scripting"
echo $?


echo Hello || echo World
echo $?

! echo hi
echo $?

n=4

test $n -gt 1 && test $n -lt 10
echo $?

[ $n -gt 1 ] && [ $n -lt 10 ]
echo $?

((n>1 && n<10))
echo $?

