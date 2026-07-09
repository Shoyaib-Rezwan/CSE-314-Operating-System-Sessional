#!/usr/bin/bash

OLD_IFS="$IFS" #Internal File Separator

data="Banana,Orange,Apple"

IFS=","
for fruit in $data; do
    echo "Fruit: $fruit"
done

IFS="$OLD_IFS"  # IFS is global variable. In order to prevent system crash, it's better to set it back to it's old value

# if you want to change the variable temporarily, you can follow the following syntax
# tbh, this can be done for any 

IFS="," read -r fruit1 fruit2 fruit3 <<<$data

echo "$fruit1"
echo "$fruit2"
echo "$fruit3"
