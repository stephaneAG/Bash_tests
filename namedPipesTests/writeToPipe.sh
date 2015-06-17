#!/bin/bash

# The following shell script writes to the pipe created by the read script.
# First, it checks to make sure the pipe exists, then it writes to the pipe.
# If an argument is given to the script, it writes it to the pipe; otherwise, it writes "Hello from PID".

# to run: sh writeToPipe.sh
# or      sudo chmod +x ./writeToPipe.sh

pipe=/tmp/testpipe

if [[ ! -p $pipe ]]; then
    echo "Reader not running"
    exit 1
fi


if [[ "$1" ]]; then
    echo "$1" >$pipe
else
    echo "Hello from $$" >$pipe
fi
