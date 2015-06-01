#!/bin/bash

# server.sh - server_client_test

# check the port passed as parameter
port=2345
directory=`dirname $0`
documents=$directory/documents

# the fcn the acts as a server
_serve(){
  # loop
  while true
  do
    read sock_msg
    case $sock_msg in
      i | index )        # list the files present in the current directory's 'documents' directory
        ls $documents ;;
      get\ * )           # get the content of one of the file located in the current directory's 'documents' directory
        file=${sock_msg#get} #
	echo "-- $file --"
	# as it seems I have a problem the original author of one of the notes I read had not ..
	file=`echo "$file" | sed 's/^ *//g'`  # remove trailing whitespace form the var
	cat $documents/$file 
	echo "-----------" ;;
      t | time )        # get the current time of the server
        date ;;
      u | uptime )      # get the current uptime of the server
        uptime ;;
      * )               # for everything else, display a list of the supported commands
        echo "bash sock_srvr v0.1a"
	echo "supported commands: t, time; u, uptime, i, index; get <filename>"
	echo "ctrol-C to exit"
    esac
    echo -n "> "        # display a prompt to the client connected
  done
}

# we start our "_server()" as a background coprocess called "SOCKSRVR"
# its 'stdin' file handle is "${SOCKSRVR[1]}" & its 'stdout' is "${SOCKSRVR[0]}"
coproc SOCKSRVR { _serve; }

# we start a netcat server, with its 'stdin' redirected from SOCKSRVR's 'stdout',
# & its 'stdout' redirected to SOCKSRVR's 'stdin'
nc -l $port -k <&${SOCKSRVR[0]} >&${SOCKSRVR[1]}
