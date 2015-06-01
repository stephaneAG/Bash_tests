#!/bin/bash

# IFS test for simple variables printing / parsing
#old_IFS=$IFS # save IFS
#cat settings.kupa | while read user ip port path
while read user ip port path
do
	echo "Nom: $user Ip: $ip Port: $port Remote path: $path"
done < settings.kupa
#IFS=$old_IFS # restore IFS
