#!/bin/bash

# tput tests

# save the cursor's postion
tput sc

sleep 4 # wait a little bit

echo "not-THAT 'loooool'"

sleep 2

echo "****** it, whatever ..."

sleep 2

echo ".. I'll continue to act as I think ( ..)."

sleep 4 # wait a little bit

# restore the cursor's position
tput rc

sleep 2

echo -e "\r\033[K"
echo -e "\r\033[K These are my last words ..."
#echo "\r\033[K"

exit 0
