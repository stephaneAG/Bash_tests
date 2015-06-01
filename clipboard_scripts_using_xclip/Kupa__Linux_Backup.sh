#!/bin/bash

##	Kupa__Linux.sh - part of the Kupa Project

##	usage principle:
##
##	A user hits his favorite 'Ctrl-C' or 'Command-C' shortcut to copy some text stuff to its OS's clipboard
##	Then, the user can choose to make available that content on other computers he wishes to.
##	In the Kupa folder, a 'settings.kupa' file can be edited to add as many computers as wanted: it holds the list of the computers the Kupa clipboard will be accessible to
##	
##	To be able to use Kupa correctly, a user needs to have shared ssh keys to all the computers he wishes to use Kupa on
##
##	For Linux users, Kupa requires 'xclip' to be installed ( used for clipboard management ) as well as ??? ( used to display Kupa alerts about available stuff from the Kupa clipboard )
##
##
##	by StephaneAG - 2013


## the user hits 'Ctrl-C' or 'Command-C' to copy some text content to the clipboard

## we copy the stuff present in the clipboard to the Kupa's "./shared" directory
# we get the current content of the clipboard using 'xclip'
FROM_CLIPBOARD=`xclip -out -selection -c ./shared`
# as wip implm , we echo the content of the clipboard
echo "[DEBUG] current clipboard content: ""'""$FROM_CLIPBOARD""'"
echo ""
## we use the 'settings.kupa' file to get all the 'clients' we will send the content to
# we verify that the file is indeed present in the current directory
KUPA_SETTINGS_FILE="./settings.kupa"
KUPA_PARAMS_NUMBER="4"

if [ -f "$KUPA_SETTINGS_FILE" ]
then
	echo "$KUPA_SETTINGS_FILE file found"
	
	# the settings file exists, so we can start reading it line by line
	old_IFS=$IFS # save the Internal Field Separator before modifying it
	IFS=$'\n' # set it to the new line character
	for line in $(cat $KUPA_SETTINGS_FILE)
	do
		#echo "'" "$line " "'"
		# check if the line begins with a double '##' , wich would indicate it's not an actual setting line but a comment
		# strip the new line character of the string if any
		
		
		if [[ ! $line == "##"* ]] # to read: if the line doesn't match with the following RegExp ( aka doesn't start with '##')
		then
			#echo $line # its actually a reali setting line, so we are now going to parse it
			
			# we now check if each setting line has enough paramters ( 4 : <name> <ip_address> <port> <remote_path_to_Kupa>
			IFS=$old_IFS # we 'escape the modified IFS'
			parameters_count=0;
			for param in $line
 			do 
				parameters_count=$((parameters_count+1))
			done
			IFS=$'\n' # we re-modifiy the just-de-modified IFS

			echo "Parameters count for current line: $parameters_count"
			# if there's is less than 4 parameters for any line, we skip it and display an error instead of purely exiting the program directly
			if [ "$parameters_count" -lt "$KUPA_PARAMS_NUMBER" ] # if there is not less than 4 parameters for the current line 
			then
				echo "Not Enough parameters: skipping current client ( line number in settings file here in the future )  ..."
			else
				echo "Suffiscient number of parameters: proceeding ..."
				# now we know that we have all the needed parameters, we can proceed in sharing the content of the clipboard to other users
				#  note: we could also have saved the content of the clipboard to a local file before sending it (...)

				# parse the parameters found in the current line

				# check if the a remote Kupa directory or script is found for the current client ( corresponding to current line ) using the remote path found in the provided parameters
					# if it is indeed found, try to execute a scp command to copy the content of the clipboard held into a file at the remote location, in Kupa's ./received/ directory
					# then, execute one o the Kupa's script to alert that client that new content is available from the Kupa's clipboard
					# note: we could also alert the user whom content is originating from that it has been made available to the current client's Kupa clipboard (...)
				
			fi

			#  CAREFUL: we re-modify the IFS as we now wanna have it handling spaces ( the default for the 'for' loop )
			IFS=$old_IFS
			for word in $line
			do
				echo "$word | "
			done
			# CAREFUL: and once done, we re-set our IFS to a new line character to prepare the next line's read
			IFS=$'\n'
			
			# to make the output more readable on the terminal, print a new line character after each line read
			echo ""
		fi

	done
	IFS=$old_IFS # restore the IFS back to its original value
	
else
	echo "$KUPA_SETTINGS_FILE file not found"
	exit 1
fi



## we actually send the content to the "./received" directory of the distant Kupa directory
# scp ...

## we remotely execute a command on all the client ( that command actually displays an alert about the new stuff available from the Kupa clipboard )
# ssh ...

## any of the clients can now execute the 'Kupaste' shortcut ( or call Kupa with the -paste argument ) to copy the Stuff present in the Kupa clipboard to its actual clipboard
## note: a Kupa 'short-shortcut' is also available to copy the stuff from the Kupa clipboard AND directly paste it all in single a row ( thanks to AppleScript of Mac OS )

