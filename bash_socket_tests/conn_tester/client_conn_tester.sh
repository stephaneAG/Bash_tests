#!/bin/bash

# client_conn_tester.sh - test a conn until it fails

# proof-of-concept - dirty code
#while true
#do
#  (echo >/dev/tcp/localhost/2345) && >/dev/null && echo "conn open" || echo "conn closed"
#  sleep 2
#done

## --

# - vars -
ip_addr="localhost"
port=2345
program_path="./billy_looper.sh"
program_run_delay=10
counter=0
counter_max=10
looping_sleep=2
# - fcns -

# fcn that displays the correct syntax(es) to call the script, with the necessary arguments for the different version of the setup
_stdoutScriptSyntax(){
  echo "3 arguments syntax: <IP address> <port> <filepath to program>"
  echo "6 arguments syntax: <IP address> <port> <filepath to program> <program run delay> <counter maximum> <looping sleep>"
}
# fcn that checks the number of arguments passed, & set the necessary variables accordingly
_cliArgs(){
  if [ $# -eq 0 ] || [ $# -lt 3 ]
  then
    echo "Need at least 3 arguments: <IP address> <port> <filepath to program>"
    exit 1 # exit with an error
  fi

  if [ $# -eq 3 ]
  then
    ip_addr=$1
    port=$2
    program_path=$3
    echo "3 arguments setup selected: <$ip_addr> <$port> <$program_path>"
  fi

  if [ $# -eq 6 ]
  then
    ip_addr=$1
    port=$2
    program_path=$3
    program_run_delay=$4
    counter_max=$5
    looping_sleep=$6
    echo "6 arguments setup selected: <$ip_addr> <$port> <$program_path> <$program_run_delay> <$counter_max> <$looping_sleep>"
  fi

}
# fcn that launches an external program in the background ( so as not to necessarily keep the current script open )
_runExternalProgram(){
  #$program_path & # I'd love this to work as expected 1st try ;p .. it DID ! :D
  nohup $program_path >"$program_path".log 2>&1 </dev/null &
}
# fcn that handles displaying the counter status, counting, as well as checking the count status ( aka "where we're at" )
_handleCounter(){
  # display the courrent counter's value
  echo "Counter equals $counter"
  # check where we're at ( aka "how big is the counter" )
  _handleCounterMax
}
# fcn that handles what tot do when the counter reaches its maximum
_handleCounterMax(){
  #echo "invoked _handleCounterMax .."
  if [ $counter -lt $counter_max ]
  then
    echo "counter < counter_max"
    counter=$[counter + 1] #`expr $counter + 1` # increment the counter
  elif [ $counter -eq $counter_max ]
  then
    echo "counter = counter_max"  
    echo "Initiating program run with delay of $program_run_delay"
    sleep $program_run_delay
    echo "Runnig external program .."
    echo "TIMESTAMP: " `date`
    _runExternalProgram & # run the external program
    exit 0
  fi
}
# fcn that tries to connect to the default gateway
_tryConnectToGateway(){
  #ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null && echo conn open || echo conn closed
  ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` 2>&1>/dev/null && echo conn open || echo conn closed
}

# fcn that tries to connect to the server
_tryConnectToServer(){
  #conn_status=`(echo >/dev/tcp/localhost/2345) && >/dev/null && echo "conn open" || echo "conn closed"`
  #status=`(echo >/dev/tcp/localhost/2345) && 2>&1>/dev/null && echo "conn open" || echo "conn closed"`
  #conn_status=`(echo >/dev/tcp/localhost/2345) && 2>/dev/null && echo "conn open" || echo "conn closed"`
  #conn_status=`(echo >/dev/tcp/localhost/2345) && 2>&1>/dev/null && echo "conn open" || echo "conn closed"`
  conn_status=`(echo >/dev/tcp/${ip_addr}/${port}) && 2>&1>/dev/null && echo "conn open" || echo "conn closed"`

  echo "$conn_status"
}
# fcn that handle the conn trials
_handleTryConnect(){
  conn_res=`_tryConnectToServer` # to debug / debunk
  #conn_res=`_tryConnectToGateway` # testing the connection to the gateway
  if [ "$conn_res" == "conn closed" ]
  then
    echo "..Connection is closed.."
    _handleCounter # display & check the counter to later increment it OR act accordingly
  elif [ "$conn_res" == "conn open" ]
  then
    # conn is open
    echo "..Connection is open.."
    counter=0 # we reset the counter as the connection is open -> no radiowaves are around us ;p
  fi
}

# fcn that loops infinately
_loop(){
  for (( ; ; ))
  do
    loop # actual loop
    sleep $looping_sleep # sleep the time specified
  done
}

# stuff that needs to loop go in the following fcn
loop(){
  _handleTryConnect # try to connect to the server & act accordingly ( .. )
}

## --

# check cli arguments:
# minimum:    <IP address> <port> <filepath to program>
# complete:   <IP address> <port> <filepath to program> <program run delay> <counter maximum> <looping sleep>
_cliArgs $@ # setup the necessary variables using the cli arguments ( we pass it all the arguments received from the cli )

# loop
_loop # "main" loop fcn
## --
