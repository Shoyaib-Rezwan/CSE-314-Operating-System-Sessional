#!/usr/bin/bash

if true
then
	echo "true condition"
fi

if true ; then
	echo "You can see me"
fi

if ! echo "hello" ; then
	echo "world"
fi

n=5
if test $n -eq 5; then
	echo "n is 5"
fi

if [ $n -lt 10 ] ; then
	echo "n is less than 10"
elif [ $n -eq 10 ] ; then
	echo "n equals 10"
else 
	echo "n is greater than 10"
fi

if test $n -gt 2 && test $n -lt 8 ; then
	echo " 2 < n <8 "
fi

if [ $n -gt 2 ] && [ $n -lt 8 ] ; then
	echo " 2 < n <8 "
fi

if [[ $n > 2 ]] && [[ $n < 8 ]] ; then
	echo " 2 < n <8 "
fi

if [[ $n > 2 && $n < 8 ]] ; then
	echo " 2 < n <8 "
fi

if [[ $n -ge 2 && $n -le 8 ]] ; then
	echo " 2 < n <8 "
fi

if (( $n >= 2 && $n <= 8 )) ; then
	echo " 2 < n <8 "
fi











