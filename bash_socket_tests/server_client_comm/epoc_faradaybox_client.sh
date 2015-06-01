#!/bin/bash

# epoc_faradaybox_client.sh
#
# to be used with the epoc_faradaybox_server.sh
# or
# "nc -l 2345" || "nc -k -l 2345" ( to keep the server up after a disconnection )
#
# by StephaneAG - 2014

## --

# - vars -
loopsWithoutServerPING=0 # counter to decide when to run the external program
maxLoopsBeforeProgramRun=10 # once the above counter reaches this value, the external program is run
sockServerMsg="" # var to hold the latest message received from the server

# - fcns -
_connectToServer(){
  exec 3<>/dev/tcp/$1/$2 # Syntax: "exec 3<>/dev/tcp/<address>/<port>"
  _writeToSocket Hello there Mr. UPS MAN # works
}
_writeToSocket(){
  echo "$@" >&3 # write stuff passed to the socket
}

## -- TEST WITH A CAST INSTEAD OF READ -> IT SHOULD NOT BLOCK (..) -- ##

_readFromSocketInLoop(){
  while read sockmsg <&3
  do
    [ -z "$sockmsg" ] && continue # skip empty lines
    echo "epoc_faradaybox_client:: received data from the server .."
    _socketCallback $sockmsg # pass the stuff received to the socket callback fcn for processing
  done
}
_readFromSocket(){
  #read sockmsg <&3 # read ONE LINE ONLY from the socket # trying to add the timeout parameter ( if this was the thing blocknig .. )
  read -t 1 sockmsg <&3 # read with a timeout of 1 second 
  #sockmsg$`cat <&3` # let's see if a 'cat' is also 'blocking' ..
  #[ -z "$sockmsg" ] && continue # skip empty lines
  
  echo "epoc_faradaybox_client:: received data from the server .."
  _socketCallback $sockmsg # pass the stuff received to the socket callback fcn for processing
}
_socketCallback(){
  #echo "epoc_faradaybox_client:: socket callback -> non-empty message received ( can be newline ): $@"
  sockServerMsg="$@" # pass all arguments received by the "socketCallback" fcn as the msg content
  #echo "epoc_faradaybox_client:: socket callback -> message saved in buffer: $sockServerMsg"
}
_resetLoopsCounter(){
  loopsWithoutServerPING=0 # reset the loopsWithoutServerMsg counter
}
_clearSockBuffer(){
  sockServerMsg="" # empty the content of the "sockServerMsg" variable
}
_logServerConnLost(){
  echo "epoc_faradaybox_client:: server connection lost !"
  date # print the moment the connection was lost
  sleep 10
  exit 0
}
_handleMaxLoopsReached(){
  if [ "loopsWithoutServerPING" == "$maxLoopsBeforeProgramRun" ]
  then
    echo "epoc_faradaybox_client:: counter reached its maximum -> running external program .."
    _startExternalProcess # start an external process ( nb: IN BACKGROUND !, or it'll get killed as well as the current one )
    exit 0 # exit without errors
  fi
}
_startExternalProcess(){
  echo "delaying external program execution"
  echo "Starting external process .." # dummy message for the moment
}
_handleSockMsg(){
  #echo "epoc_faradaybox_client:: _handleSockMsg invoked !"
  # check if the message held in our var is empty
  if [ "$sockServerMsg" == "" ]
  then
    echo "epoc_faradaybox_client:: _handleSockMsg -> reception buffer is empty !"
    _logServerConnLost # log the loss of the server connection
    loopsWithoutServerPING=`expr $loopsWithoutServerPING + 1` # increment our counter
    echo "epoc_faradaybox_client:: loops without server PING = $loopsWithoutServerPING"
  else
    echo "epoc_faradaybox_client:: _handleSockMsg -> buffer is not empty: invoking _handleEpocFraradayboxMsg .."
    _handleEpocFraradayboxMsg # do further processing in the "_handleEpocFraradayboxMsg()" fcn
  fi
}
_handleEpocFraradayboxMsg(){
  #echo "epoc_faradaybox_client:: _handleEpocFraradayboxMsg invoked !"
  # process the message received from the server
  case $sockServerMsg in
    epocping | epoc_faradaybox_server__PING )            # "PING" received from the server
    echo "epoc_faradaybox_client:: _handleEpocFraradayboxMsg -> received server PING"
    _writeToSocket epoc_faradaybox_client__PONG ;; # echo a "PONG" back to the server
    epoctime | epoc_faradaybox_client_time )             # "time" request from the server
    echo "epoc_faradaybox_client:: _handleEpocFraradayboxMsg -> received time request"
    _writeToSocket date ;;  # echo the output of the 'time' cmd
    * )                                                  # everything else ( .. )
    echo "epoc_faradaybox_client:: _handleEpocFraradayboxMsg -> unknown command: $sockServerMsg"
  esac

  _resetLoopsCounter # reset the loop counter
  _clearSockBuffer # clear the message from the "buffer variable"
}
_loop(){
  for (( ; ; ))
  do
    _handleMaxLoopsReached # check if we haven't reached yet the maximum times we can loop without receiving message from the server
    _readFromSocket # read from the socket to the "buffer variable"
    _handleSockMsg # handle the socket message saved in the buffer

   _writeToSocket epoc_faradaybox_client_PONG_loop

  sleep 1 # sleep a littl' while ..
  done
}

## --

# receive the IP address & the port as cli arguments connect to the server
# for now, hardcoded
_connectToServer localhost 2345

# write a "I exist !" message to the socket for the server to knoq we're there
_writeToSocket epoc_faradaybox_client_PONG_start

# loop
_loop # loop until we've lost the connection with the server fora suffiscient amount of time ( necessary  )
## --
