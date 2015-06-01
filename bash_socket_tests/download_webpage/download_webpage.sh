#!/bin/bash

# simple test on using "bash's native sockets" to download a webpage

## --

# connect to a webpage using TCP on port 80
exec 3<>/dev/tcp/www.fedoraproject.org/80
# echo a GET request & have its content to &3
echo -e "GET" /\" >&3
# read from it
cat <&3

## --
