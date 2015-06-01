#!/bin/bash

# trying to clear some previously written lines

# print stg recognizable
echo "clearing lines test:"

# save the cursor's position
#echo -en "\033[s"
#tput sc

# print dummy lines
echo -en "gdfgdfgdfgfg\ncvbcvbcvbcvbcvb"

sleep 4

# remove last line
#echo -en "\r\033[K\r\033[K jojoba ?"

# restore cursor's postion
#echo -en "\033[u"
#tput rc

# print dummy stuff
echo "lolo lili"
echo "lala lulu"

sleep 4

# print stg recognizable
echo "clearing lines tests complete!"

exit 0
