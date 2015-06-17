#!/bin/bash

# The following shell script reads from a pipe. 
# It first creates the pipe if it doesn't exist, then it reads in a loop till it sees "quit"

# to run: sh readFromPipe.sh &
# or      sudo chmod +x ./readFromPipe.sh

pipe=/tmp/testpipe

#trap "rm -f $pipe" EXIT
trap "rm -f $pipe; exit;" INT TERM EXIT

if [[ ! -p $pipe ]]; then
    mkfifo $pipe
fi

while true
do
    if read line <$pipe; then
        if [[ "$line" == 'quit' ]]; then
            break
        fi
        echo $line
    fi
done

echo "Reader exiting"
