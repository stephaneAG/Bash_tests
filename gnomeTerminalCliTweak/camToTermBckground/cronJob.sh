#!/bin/bash

# the following script is intended to be used as a cron job ( aka, being invoked by the crontab )
# it doesn't rely on any aliases -> not any more :/ [ but tests 'll be made to make sure we can use them from it, else I don't see the point of not using my existing aliases .. :D ]

# TODO: find a way to make gconftool-2 work with cron !


# source our commands
#source ~/.bashrc

#if [ -z "$DBUS_SESSION_BUS_ADDRESS" ] ; then
#  # this is because of gconftool bug in cron
#  TMP=~/.dbus/session-bus
#  export $(grep -h DBUS_SESSION_BUS_ADDRESS= $TMP/$(ls -1t $TMP | head -n 1))
#  echo $DBUS_SESSION_BUS_ADDRESS >> $LOG
#fi

#export DISPLAY=0

#while read line ; do
#echo $line | grep -vqe "^#"
#if [ $? -eq 0 ]; then export $line; fi
#done < ~/.dbus/session-bus/$(cat /var/lib/dbus/machine-id)-$DISPLAY


. ~/.bash_stephaneag_functions

# get the current gnome-terminal profile & cam image path
#scriptNamespace="camToTermBckgrnd"
#currTermProfile=`stag__scriptsDb_get ${scriptNamespace}.profile`
#camImg_storagePath='/home/stephaneag/Documents/Development/dev__shell/gnomeTerminalCliTweak/camToTermBckground/camImg.png'

# call our alias
stag__gnomeTerm_camToTermBackground_cronScript
