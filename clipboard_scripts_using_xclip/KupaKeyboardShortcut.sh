#!/bin/bash

# test file to determine how we can execute a custom bash script in an .sh file from a keyboard shortcut ( hotkey )
# works with poping a xterm window not auto-closing( xterm -e "bash /home/stephaneag/Documents/Development/dev__shell/clipboard_scripts_using_xclip/shortcutTest.sh; bash" )
# and also with an auto-closing xterm window ( xterm -e "bash /home/stephaneag/Documents/Development/dev__shell/clipboard_scripts_using_xclip/shortcutTest.sh" )

# do a dummy echo ( won't be visible unless we show a terminal from the keyboard shortcut command executed )
echo "Kup Keyboard Shortcut called: executing the Kupa_Linux program .." # 

# go to the right directory before calling the Kupa script
cd /home/stephaneag/Documents/Development/dev__shell/clipboard_scripts_using_xclip/

# create a dummy file in the current folder ( so we'll be able to see if the script worked or not without tu use voice ;p )
#touch dummyFileKeyboardShortcutTest # seems to create a file at root ( /home/stephaneag/dummyFile... )



# WIP : could actually be inside the Kupa__Linux.sh script itself ( nb: still needs 'xsel' to be installed )
# copy the output of the 'xsel' command ( the current [text] selection in any app ) and pipe it to the 'xclip' command ( wich actually copies the content to the clipboard )
xsel | xclip -selection clipboard

# acutally call the Kupa script from the current folder
./Kupa__Linux.sh

# exit the script with no errors ( maybe it is what I was missing ?? )
# seem to work flawlessly using xterm ( as explined above ) and without specifying 'exit 0'
#exit 0 # works fine with the 'exit 0', trying without


# say hello to the world
#spd-say -t male3 -p 100 -r 22 -i -70 "Hello world"
