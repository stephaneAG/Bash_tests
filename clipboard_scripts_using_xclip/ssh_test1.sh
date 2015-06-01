#!/bin/bash

# the purpose of this file is to serve as test & reference for further devs

# test if a file is found at a remote location
ssh -q stephaneadamgarnier@192.168.1.7 -p 22 [[ -f /Applications/Kupa/Kupa.node ]] && echo "Kupa node found at remote address" || echo "Kupa node not found at remote address" # ex for macbookpro on Mac OS

# as a reminder: how to execute several commands LOCALLY if a file is found AT A REMOTE LOCATION on multiple line using a 'customized' version of tha above syntax 
#ssh -q "$login"@"$ip_address" -p "$port" [[ -f "$remote_path" ]] && \
#                                        { echo "FOUND"; \
#                                        echo "doing neat things ..."; \
#                                        echo "and doing stuff"; } || echo "Not found"


# to specify to use the bash shell on the remote side & execute a local script on the remote location
ssh stephaneadamgarnier@192.168.1.7 -p 22 'bash -s' < localscript_toexecuteremotely.sh

# also works
localScriptFile="localscript_toexecuteremotely.sh"
ssh stephaneadamgarnier@192.168.1.7 -p 22 'bash -s' < "$localScriptFile" # or just $localScriptFile




# to pass local variables to commands running on a remote host
myargument1="Tef"
myargument2="Hello"
ssh stephaneadamgarnier@192.168.1.7 -p 22 myargument1=$myargument1 myargument2=$myargument2 'bash -s' <<'ENDSSH'
# commands to be run on the remote location
echo "[macbookpro]will say something on the macbookpro"
say "$myargument1 says $myargument2 and have a nice day"
echo "[macbookpro]should have said something on the macbookpro"
ENDSSH

# to simply run command on a remote host
ssh stephaneadamgarnier@192.168.1.7 -p 22 <<'ENDSSH'
# commands to be run on the remote host
echo "[macbookpro]a simple command"
ENDSSH

# example of nested commands
#ssh stephaneadamgarnier@192.168.1.7 -p 22 <<'ENDSSH'
# commands to be run on the first remote host
# ssh stephaneadamgarnier@192.168.1.7 -p 22 <<'ENDSSH2'
 #commands to be run on the second remote host
#  wall <<'ENDWALL'
#   Error: Out of cheese
#  ENDWALL
#  
#  ftp ftp.scureftp-test.com <<'ENDFTP'
#  test
#  test
#  ls
#  ENDFTP
#
# ENDSSH2
#
#ENDSSH




# to execute a remote script with local parameters values ( that can contain spaces )
#myarg='/Applications/Kupa/Kupa.node Tef "a fake clipboard content"'
#ssh stephaneadamgarnier@192.168.1.7 -p 22 < "echo $(printf '%q' '$myarg')"
echo "The following HAS to work !"
KupaHost='StephanAGzenbook'
ssh stephaneadamgarnier@192.168.1.7 -p 22 hostArg=$KupaHost 'bash -s ' <<'ENDKUPA'
# a command that will be run on the remote location that actually uses the passed arguments
echo "[macbookpro]"

# pass the arguments to our script located on the distant host: it will handle some stuff in the future (...)
/bin/bash /Applications/Kupa/Kupa.node "$hostArg" # WORKS
#/bin/bash /Applications/Kupa/Kupa.node "$hostArg" "$(printf '%q' "$contentArg")"


# WIP: copy the content to the clipboard of a Mac OS based system
#echo "some other sample text for more tests !" | /usr/bin/pbcopy # WORKS
#echo "$contentArg" | /usr/bin/pbcopy # not working
#echo " $(printf '%q' "$contentArg")" | /usr/bin/pbcopy
# WIP UPDATE: a simpler, safer, and cleaner solution is to use scp to copy the 'shared_clipboard.kupa' file to the remote host and then to pipe its content to pbcopy (...)
/usr/bin/pbcopy < /Applications/Kupa/received/shared_clipboard.kupa # WORKS

# test-display the above variable content
#echo "content equas to $(printf '%q' "$contentArg")"

# use growlnotify on the distant host to inform the user that new content is available
/usr/local/bin/growlnotify -m "Kupa clipboard updated by $hostArg" "Kupa" --image /Applications/Kupa/debian-logo.png --sticky
echo "[macbookpro] Kupa clipboard updated" 
ENDKUPA


# to inform the user on the local host that the Kupa share dclipboard has been updated on all the clients specified in the clients_settings.kupa file
notify-send "Kupa" "The Kupa shared clipboard has been succefully uploaded to specified clients !" -i /usr/share/pixmaps/debian-logo.png


# executing a script on the distant host without passing any arguments
#ssh stephaneadamgarnier@192.168.1.7 -p 22 "/usr/local/bin/growlnotify -m "Hey there !" "Kupa" --image /Applications/Kupa/debian-logo.png --sticky # WORKS
