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
FROM_CLIPBOARD=`xclip -out -selection ` #-c ./shared`
# as wip implm , we echo the content of the clipboard
echo "[DEBUG] current clipboard content: ""'""$FROM_CLIPBOARD""'"
echo ""
## we use the 'settings.kupa' file to get all the 'clients' we will send the content to
# we verify that the file is indeed present in the current directory
KUPA_SETTINGS_FILE="./settings.kupa"
KUPA_SHARED_FILE="./shared/shared_clipboard.kupa"
KUPA_DISTANT_NODE_PATH="/Kupa.node"
KUPA_HOST_OS_MAC="Mac"
KUPA_HOST_OS_NIX="Linux"
#KUPA_PARAMS_NUMBER="4"
KUPA_PARAMS_NUMBER="5"

# 0: check the presence of a 'Kupa node' in the current directory

# 1: check if there's any file left in the './shared' directory of Kupa
if [ -f "$KUPA_SHARED_FILE" ]
then
	echo "[DEBUG] a previous Kupa shared clipboard was found in the ./shared/ directory."
	rm "$KUPA_SHARED_FILE"
	echo "[DEBUG] the previous Kupa clipboard was successfully deleted."
else
	echo "[DEBUG] no previous Kupa shared clipboard was found in the ./shared/ directory."
fi

# make some space on stdout
echo ""
echo ""

# 2: copy the stuff present in the clipboard variable to a local file as './shared/shared_clipboard.kupa'
xclip -out -selection -c > ./shared/shared_clipboard.kupa
echo "[DEBUG] current clipboard content has been copied to local shared clipboard file."
echo ""

# check if the Kupa settings file exist bofore further proceeding
if [ -f "$KUPA_SETTINGS_FILE" ]
then
	echo "[DEBUG] $KUPA_SETTINGS_FILE file found"
	
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

			echo "[DEBUG] Parameters count for current line: $parameters_count"
			# if there's is less than 4 parameters for any line, we skip it and display an error instead of purely exiting the program directly
			if [ "$parameters_count" -lt "$KUPA_PARAMS_NUMBER" ] # if there is not less than 4 parameters for the current line 
			then
				echo "[DEBUG] Not Enough parameters: skipping current client ( line number in settings file here in the future )  ..."
			else
				echo "[DEBUG] Suffiscient number of parameters: proceeding ..."
				# now we know that we have all the needed parameters, we can proceed in sharing the content of the clipboard to other users
				#  note: we could also have saved the content of the clipboard to a local file before sending it (...)

				# parse the parameters found in the current line
				IFS=$old_IFS # we 'escape the modified IFS'
				
				#aline="StephaneAG 192.168.1.12 22 /home/stephaneag/Kupa"
				IFS=' ' read -a array <<< "$line" # split the line string into an array
				# accessing elements individually 
				#echo "${array[0]}"
				#echo "${array[1]}"
				#echo "${array[2]}"
				#echo "${array[3]}"
				
				# to display them in a single row
				echo "[Client settings] Username: ${array[0]}    Login: ${array[1]}     IP Adress: ${array[2]}      Port: ${array[3]}      Remote path: ${array[4]}"

				#while read user ip port path
				#do
        			#	echo "Username: $userIp      Ip: $ip      Port: $port      Remote path: $path"
				#done < $line # $KUPA_SETTINGS_FILE
				
				IFS=$'\n' # we re-modifiy the just-de-modified IFS
				
				
				# check if the a remote Kupa node is found for the current client ( corresponding to current line ) using the remote path found in the provided parameters
				kupa_node_found=0
				username="${array[0]}"
				login="${array[1]}"
				ip_address="${array[2]}"
				port="${array[3]}"
				remote_path="${array[4]}"
				#ssh -q stephaneadamgarnier@192.168.1.7 -p 22 [[ -f /Applications/Kupa/Kupa.node ]] && echo "Kupa node found at remote address" || echo "Kupa node not found at remote address"
				#ssh -q "$login"@"$ip_address" -p "$port" [[ -f "$remote_path" ]] && echo "Kupa node found at remote address" || echo "Kupa node not found at remote address"
				#ssh -q "$login"@"$ip_address" -p "$port" [[ -f "$remote_path" ]] && \
				#	echo "Found" || echo "Not found"
				
				# prepare some useful variables to be passed as arguments to the distant script ( yep, passing LOCAL arguments to a DISTANT script )
				kupa_remote_node_path="$remote_path$KUPA_DISTANT_NODE_PATH"
				echo "[CLients settings] Client Kupa node should be located at: $kupa_remote_node_path"

				ssh -q "$login"@"$ip_address" -p "$port" [[ -f "$remote_path""$KUPA_DISTANT_NODE_PATH" ]] && \
                                        { echo "[DEBUG] Kupa node FOUND at remote location."; \
					echo "[DEBUG] scping the file to the remote location ..."; \
					# scp -P 22 ./shared/shared_clipboard.kupa stephaneadamgarnier@192.168.1.7:/Applications/Kupa/received/
					scp -P "$port" "$KUPA_SHARED_FILE" "$login"@"$ip_address":"$remote_path/received/" ; \
					# execute remote commands
# nb: the weird indentation is completely normal
#ssh stephaneadamgarnier@192.168.1.7 -p 22 the_kupa_node=$kupa_remote_node_path 'bash -s ' <<'ENDKUPA'
ssh stephaneadamgarnier@192.168.1.7 -p 22 the_kupa_node=$kupa_remote_node_path the_kupa_remote_path=$remote_path 'bash -s ' <<'ENDKUPA'
# execute the needed command on the remote host by passing vars to a distant Kupa script
# purpose of fun test implm
#say "I am walking on a rainbow yep walking on a rainbow" &
# act & inform the distant client using its Kupa node and its settings
echo "Calling distant Kupa node ..."
echo "going to the right directory"
cd $the_kupa_remote_path
echo "Current directory:"
pwd
echo "handling remote execution ..."
/bin/bash $the_kupa_node -klipboard-update receiver &
#/Applications/Kupa/Kupa.node -klipboard-update receiver &
 
ENDKUPA
					echo "[DEBUG] Kupa node update done"; } || echo "[DEBUG] Kupa node NOT found at remote location."
				
				
					# if it is indeed found, try to execute a scp command to copy the content of the clipboard held into a file at the remote location, in Kupa's ./received/ directory
					# then, execute one o the Kupa's script to alert that client that new content is available from the Kupa's clipboard
					# note: we could also alert the user whom content is originating from that it has been made available to the current client's Kupa clipboard (...)
				
			fi

			#  CAREFUL: we re-modify the IFS as we now wanna have it handling spaces ( the default for the 'for' loop )
			#IFS=$old_IFS
			#for word in $line
			#do
			#	echo "$word | "
			#done
			# CAREFUL: and once done, we re-set our IFS to a new line character to prepare the next line's read
			#IFS=$'\n'
			
			# to make the output more readable on the terminal, print a new line character after each line read
			echo ""
		fi

	done
	IFS=$old_IFS # restore the IFS back to its original value
	
else
	echo "[DEBUG] $KUPA_SETTINGS_FILE file not found"
	# TODO: echo usage here for the settings.kupa file & other stuff (...)
	exit 1
fi



## we actually send the content to the "./received" directory of the distant Kupa directory
# scp ...

## we remotely execute a command on all the client ( that command actually displays an alert about the new stuff available from the Kupa clipboard )
# ssh ...

## any of the clients can now execute the 'Kupaste' shortcut ( or call Kupa with the -paste argument ) to copy the Stuff present in the Kupa clipboard to its actual clipboard
## note: a Kupa 'short-shortcut' is also available to copy the stuff from the Kupa clipboard AND directly paste it all in single a row ( thanks to AppleScript of Mac OS )

