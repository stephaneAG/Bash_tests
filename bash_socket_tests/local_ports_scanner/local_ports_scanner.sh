#!/bin/bash

# simple test on using "bash's native sockets" to create a local port scanner

## --

echo "Scanning TCP ports .."
# loop over ports in range [1:1023]
for p in {1..1023}
do
  # ( echo >/dev/tcp/localhost/$p ) >/dev/null 2>&1 && echo "$p : open" ## version that outputs directly to stdout
  ( echo >/dev/tcp/localhost/$p ) >/dev/null 2>&1 && echo "$p : open" > open_ports__TCP  ## version that outputs to a file ( the last redirection specified )
done
echo ".. TCP ports scan done."
echo "TCP ports listing saved in the 'open_ports__TCP' file in the current directory."

echo "Scanning UDP ports .."
# loop over ports in range [1:1023]
for p in {1..1023}
do
  # ( echo >/dev/udp/localhost/$p ) >/dev/null 2>&1 && echo "$p : open" ## version that outputs directly to stdout
  ( echo >/dev/udp/localhost/$p ) >/dev/null 2>&1 && echo "$p : open" > open_ports__UDP ## version that outputs to a file ( the last redirection specified )
done
echo ".. UDP ports scan done."
echo "TCP ports listing saved in the 'open_ports__UDP' file in the current directory."

## --
