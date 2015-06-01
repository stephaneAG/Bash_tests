#!/bin/bash

# test file to determine how we can execute a custom bash script in an .sh file from a keyboard shortcut ( hotkey )
# works with poping a xterm window not auto-closing( xterm -e "bash /home/stephaneag/Documents/Development/dev__shell/clipboard_scripts_using_xclip/shortcutTest.sh; bash" )
# and also with an auto-closing xterm window ( xterm -e "bash /home/stephaneag/Documents/Development/dev__shell/clipboard_scripts_using_xclip/shortcutTest.sh" )

# do a dummy echo ( won't be visible unless we show a terminal from the keyboard shortcut command executed )
echo "I am a dummy echo" # 

# go to the right directory before creating the dummy file
cd /home/stephaneag/Documents/Development/dev__shell/clipboard_scripts_using_xclip/

# create a dummy file in the current folder ( so we'll be able to see if the script worked or not without tu use voice ;p )
touch dummyFileKeyboardShortcutTest # seems to create a file at root ( /home/stephaneag/dummyFile... )

# exit the script with no errors ( maybe it is what I was missing ?? )
# seem to work flawlessly using xterm ( as explined above ) and without specifying 'exit 0'
#exit 0 # works fine with the 'exit 0', trying without


# say hello to the world
#spd-say -t male3 -p 100 -r 22 -i -70 "Hello world"
