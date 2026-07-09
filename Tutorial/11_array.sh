#!/usr/bin/bash

languages=(c cpp java python)

echo Languages = ${languages[@]} #neglect error

echo Languages = ${languages[1]}

echo Languages = ${#languages[@]}

languages+=(js)
echo Languages = ${languages[@]}

unset languages[1]
echo Languages = ${languages[@]}
 