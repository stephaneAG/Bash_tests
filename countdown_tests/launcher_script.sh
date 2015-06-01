#!/bin/bash

# launcher_script.sh - timed launcher to launch an external program, wait for some time, and then kill the external program previously launched

## --

# - vars -
defaultTimeout=60 # default timeOut used if no parameter is passed to override it
#sleepTime=$defaultTiemout # the "sleepTime" equals the ( overriden or not ) "defaultTimeout"
externalProcessID=0 # 'll hold the external process PID when launched
# - fcns -
_sleepAndCountdown(){
  while sleep 60 #"$sleepTime"
  do
    echo "launcher_script.sh:: waiting .."
    echo $defaultTimeout # we echo the current timeout to stdout
    defaultTimeout=`expr $defaultTimeout - 1`
  done
}
_launchExternalProcess(){
  nohup ./billy_looper.sh & # execute the external process in the background   
  externalProcessID=$! # get the PID of the last process launched in the background
}
_killExternalProcess(){
  if kill -0 $externalProcessID # we verify that there is a runnin processing correspnding to that PID
  then
    kill $externalProcessID
  fi
}

## --
echo "launcher_script.sh:: starting .."
_launchExternalProcess # launch the external process / program
_sleepAndCountdown # sleep for the specified / defualt time and display a countdown on stdout
_killExternalProcess # kill thr external process / program that was previously launched
echo "launcher_script.sh:: .. done !"

## --
