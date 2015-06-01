#!/bin/bash

# client.sh file - server_client_test
#
# to use:
#
# 1: start another script acting as as server / execute the following command in a terminal window:
# sudo netcat -l 2345
#
# 2: run the current script ( don't forget to adjust the port to the necessary settings ! ;)


## --
exec 3<>/dev/tcp/localhost/2345 # listen on a specific address & port using bash's buit-in socket capabilities ## 'll be passed as parameters to the script in a future version
# handle stuff ? ( .. )

echo "Hail, World !" >&3 # simplest way to write to the socket

sleep 3 # wip implm - wait a littl' time once

## --

# user-defined fcns ( .. )
# source . <...>


# "_readFromSocket()" fcn -- checks if we have something to read from the socket.Accepts a function as parameter ( if no parameter ( fcn ) is passed, it 'll simply echo out the lines on stdout ( .. ) )
_readFromSocket(){
  # check if we were passed any parameter -> OR BETTER: if the value of the parameter passed is a fcn
   # check if the parameter passed is indeed a fcn ? ( .. -> S.O. ! .. )
  while read LINE <&3 # while we try to read stuff from the socket
  do
    [ -z "$LINE" ] && continue # skip empty lines
    
    ## HERE WILL BE THE CHECK FOR HOW MANY TIMES WE TRIED TO GET DATA FROM THE SERVER & IT FAILED
    # aka increment a counter wich gets reset each time we receive the ~'ping back' "srvrcllbk" from the server ( .. )

    # handle the stuff received from the socket:
    # -> we could for example invoke a function passed to "-readFromSocket()", to wich we'd pass $line as a parameter
    #"$callbackFcn $LINE"; # invoke the callback fcn & pass it the $LINE as parameter for further processing
    #$1 $LINE
    #"$callbackFcn"
    socketCallback $LINE
    # -> for now, we'll just echo the cotnent of $line to stdout
    #echo "Stuff received from socket, & not an empty line ! :"
    #echo $LINE
  done
}
# TO ADD: fcn that writes some [generic] stuff to the socket
writeToSocket(){
  # we simply write all the stuff passed as parameter(s) to the socket
  # nb: parameterS as we're using "$@" & not "$1"
  echo "$@" >&3 # write stuff passed to the socket
}
# TO ADD: fcn that does an infinite loop over essentially two tasks: read from it & write to it [ & maybe wait once in a while .. ]
_loop(){
  # enter an infinite loop ..
  for (( ; ; ))
  do
    #loop # do the stuff defined in the "loop()" fcn
    _readFromSocket # handle stuff present in the socket
    #loop # do the stuff defined in the "loop()" fcn
    writeToSocket "Well, Hello there Mr. UPS man !"# write any pending stuff we have to the socket

    sleep 0.5 # sleep for a little while ( normally not THAT necessary ... except for less power/.. consuming .. )
  done
}

## --

# the final, simple function we use to handle stuff received from the socket
socketCallback(){
  echo "socketCallback:: received stuff from socket:"
  echo "$@" # echo everything received from the socket
  
  writeToSocket ".. You should have respect my authority ! .."
}
# our own "loop()" function
loop(){
  writeToSocket "Well, Hello there Mr. UPS man !" # write stg stupid to the socket, hoping the "server" 'll respond accordingly ;p
}

## --
_loop # initiate the loop
## --
