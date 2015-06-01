#!/bin/bash

# simple test on using "bash's native sockets" to connect to our localhost SSH port using TCP

## --

# connect to our localhost SSH using TCP
exec 3<>/dev/tcp/localhost/22

# now we can use cat / echo to read from / write to the socket
# example -> read from it:
cat <&3

## --
