#!/usr/bin/bash

greet="Greetings "
greet="$greet from"

name=Shoyaib
name+=" "
name+=Rezwan

echo "$greet" #This quotation is must to print the double spaces after Greetings
echo $name

greetname=0123
echo $greetname
echo $greet$name
echo ${greet}name

# the variables declared inside this script is not accessible from outside
# but variables declared outside are accessible from this script
