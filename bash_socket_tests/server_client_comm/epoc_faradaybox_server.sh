#!/bin/bash

# server.sh - server_client_test

# check the port passed as parameter
port=2345
directory=`dirname $0`
documents=$directory/documents

# a var to choose to display ">" as "prompt" or not
show_prompt="false"

# the fcn the acts as a server
_serve(){
  # loop
  while true
  do
    read sock_msg
    case $sock_msg in
      # -- epoc communication protocol --
      epoc_faradaybox_client_PONG_start )
      echo "epoc_faradaybox_server_PING"
      ;;
      epoc_faradaybox_client_PONG_loop )
      #echo "epoc_faradaybox_server_PONG_loop"
      ;;
      epoc* )
      echo "epoc command template"
      ;;
      epoc\ * )           # communicate using the 'epoc' protocol
        headset_stuff=${sock_msg#epoc} #
	# as it seems I have a problem the original author of one of the notes I read had not ..
	#file=`echo "$file" | sed 's/^ *//g'`  # remove trailing whitespace form the var 

	headset_stuff=`echo "$headset_stuff" | sed 's/^ *//g'`  # remove trailing whitespace form the var
	echo "Received: --$headset_stuff--"

	# handle stuff received from the socket
        ;;
      # -- server infos --
      t | time )        # get the current time of the server
        date ;;
      u | uptime )      # get the current uptime of the server
        uptime ;;
      * )               # for everything else, display a list of the supported commands
        #echo "bash sock_srvr v0.1a"
	#echo "supported commands: t, time; u, uptime, i, index; get <filename>"
	#echo "ctrol-C to exiti"
	echo epoc_faradaybox_server__PING
    esac

    # give a prompt back depending on the value of the "show_prompt" var
    if [ "$show_prompt" == "true" ]
    then
      echo -n "> "        # display a prompt to the client connected
    fi

  done
}

# we start our "_server()" as a background coprocess called "SOCKSRVR"
# its 'stdin' file handle is "${SOCKSRVR[1]}" & its 'stdout' is "${SOCKSRVR[0]}"
coproc SOCKSRVR { _serve; }

# we start a netcat server, with its 'stdin' redirected from SOCKSRVR's 'stdout',
# & its 'stdout' redirected to SOCKSRVR's 'stdin'
nc -l $port -k <&${SOCKSRVR[0]} >&${SOCKSRVR[1]}
