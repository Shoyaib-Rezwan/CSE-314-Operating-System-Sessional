#!/usr/bin/bash

true
echo $?    #0

false
echo $?		#1

echo "Hello World"	 # same as true statement
echo $?

(exit 41)
echo $?

test 5 -gt 3
echo $?

test 10 -lt 3
echo $?

[ 5 -eq 5 ]
echo $?

# The space after [ is mandatory. 'Cause [ is a built in shell command. So, [ will accpet arguments. 
# And arguments are space separated. The last ] must also be preceeded by a space. This ] indicates
# the end of statement.

((10<20))
echo $?

((10==20))
echo $?

((10==10))
echo $?

# if expressions generate 0 then that will be a false assignment

expr 5 - 5
echo $?

((n=5-5))
echo $?

((n=5-6))
echo $n $?
