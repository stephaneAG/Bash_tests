#!/bin/bash

## --

# check if already toggled on or off
_check_and_toggle(){
  ret_val=`gsettings get org.gnome.settings-daemon.plugins.power active`
  if [ "$ret_val" == "true" ]
  then
    gsettings set org.gnome.settings-daemon.plugins.power active false
    notify-send "stag_lid:: laptop run with lid closed: ON"
  elif [ "$ret_val" == "false" ]
  then
    gsettings set org.gnome.settings-daemon.plugins.power active true
    notify-send "stag_lid:: laptop run with lid closed: OFF"
  fi
}

## --
_check_and_toggle # run the fcn that toggles the "run when lid closed" fcnality
## --
