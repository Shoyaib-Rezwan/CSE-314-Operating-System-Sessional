#!/usr/bin/bash

echo {1..5}
echo {5..1}
echo {0..20..5} # 20 is included

echo file{1..5}.txt

echo CSE {A,B,C}_{1,2}

echo {x,{a,b}}{1,2,3}

touch 2205{001..180}.txt

ls 2205*

rm 2205{001..180}.txt