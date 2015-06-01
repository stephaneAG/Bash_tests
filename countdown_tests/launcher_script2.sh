#!/bin/bash

# launcher_script.sh - timed launcher to launch an external program, wait for some time, and then kill the external program previously launched

## --

## - vars -
defaultTimeout=20 # default timeOut used if no parameter is passed to override it
externalProcessID=0 # 'll hold the external process PID when launched
externalProcess="./billy_infinite_looper.sh" # external process / program to be launched by the launcher and killed after the requested / default timeout

timeout_RegEx='^[0-9][0-9]*$'
## - fcns -

# fcn that handle the CLI arguments
# loop over the cli parameters
_loop_over_cli_args(){
  for curr_arg in "$@"
    do
      #echo "$var"
      _change_defaults $curr_arg
    done
}
# fcn that parses the arguments & override the default values associated with them
_change_defaults(){
  if [[ "$1" =~ $timeout_RegEx ]] # if the parameter is a number preceeded by ":" , then we use use as the timeout value
  then
    defaultTimeout="$1"
    echo "launcher_script.sh:: timeout: $1"
  elif [ "$$" == "--help" ] || [ "$1" == "-h" ] # if the user is wondering about the syntax of the script ;)
  then
    echo "launcher_script.sh:: syntax: \n\t./launcher_script2.sh :<timeout value in seconds> <path to program> \n\t note: -> the params can be passed in any order ;)"
    exit 0
  else
    externalProcess="$1"
    echo "launcher_script.sh:: process/program: $1"
  fi
}
# fcn that sleep for the necessary amount of time while displaying a countdown on stdout
_sleepAndCountdown(){
  until [ "$defaultTimeout" == 0 ]
  do
    clear # clear the screen ( nicer when displaying output on stdout )
    echo "launcher_script.sh:: waiting .. $defaultTimeout"
    defaultTimeout=`expr $defaultTimeout - 1`
    sleep 1
  done
}
# fcn that launches the external process/program in the background as well as fetching his PID for later use
_launchExternalProcess(){
  #./billy_infinite_looper.sh & # execute the external process in the background   
  $externalProcess 2>&1>/dev/null & # redirect output to null ( "nohup" could also be used to stdout to a "nohup.out" file located in the working directory )
  externalProcessID=$! # get the PID of the last process launched in the background
}
# fcn with same intent as the above, but using a diffenrent way of "getting the stuff done" ( -> it's always good to have more than one jack in one's sleeve ;D )
_killExternalProcess(){
  if kill -0 $externalProcessID # we verify that there is a runnin processing correspnding to that PID
  then
    kill $externalProcessID
  fi
}

# fcn not used but that could be quite useful if we prefer to kill the process using the script name
_killExternalProcessUsingScriptName(){
  #externalProcessID=`pidof -x billy_infinite_looper.sh`
  externalProcessID=`pidof -x "$externalProcess"`
  kill $externalProcessID 2
}

## --

## - cli args -
echo "launcher_script.sh:: initiating .."
_loop_over_cli_args $@ # pass all the cli parameters to our fcn /!\  -- 'll call " _change_defaults() "

sleep 4

## --
echo "launcher_script.sh:: starting .."
echo "launcher_script.sh:: log started at: $(date)" > launcher_script_LOGS
_launchExternalProcess # launch the external process / program
_sleepAndCountdown # sleep for the specified / defualt time and display a countdown on stdout
_killExternalProcess # kill thr external process / program that was previously launched
#_killExternalProcessUsingScriptName # 2 nd version
echo "launcher_script.sh:: log ended at: $(date)" >> launcher_script_LOGS
echo "launcher_script.sh:: .. done !"

exit 0

## --
