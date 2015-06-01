#!/bin/bash

# IFS array test

line="StephaneAG 192.168.1.12 22 /home/stephaneag/Kupa"
IFS=' ' read -a array <<< "$line"

# accessing elements individually 
echo "${array[0]}"
echo "${array[1]}"
echo "${array[2]}"
echo "${array[3]}"
