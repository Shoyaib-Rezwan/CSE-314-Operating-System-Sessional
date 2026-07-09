#!/usr/bin/bash

# This is a comment

echo "Hello World"   #It can be inline comment

echo -e "print(\"hello world\")\nexit(5)" > main.py
python3 main.py

echo $?

rm main.py

(cd /)	#the command is only a subprocess and it will go back to the current directory
ls

cd /  #the command is only a subprocess and it will go back to the current direc>
ls


exit 41

