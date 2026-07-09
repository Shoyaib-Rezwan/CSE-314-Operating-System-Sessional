#!/usr/bin/bash

foo(){
    echo "Hello World"
    echo "Bye"
    return 41
}

msg=$(foo)
echo $?
echo "$msg"

bar(){
    echo "The first argument is ${1:-default1}"
    echo "The second argument is ${2:-default2}"
    echo "The total number of argument is $#"

    echo "The arguments: ${*}"
}
 

bar hello world of bash