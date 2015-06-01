#!/bin/bash
# arrow-detect.sh: Detects the arrow keys, and a few more.
# Thank you, Sandro Magi, for showing me how.
 
# --------------------------------------------
# Character codes generated by the keypresses.
arrowup='\[A'
arrowdown='\[B'
arrowrt='\[C'
arrowleft='\[D'
insert='\[2'
delete='\[3'
# --------------------------------------------
 
SUCCESS=0
OTHER=65
 
# tefEdit: add loop start
while true
do
 
#echo -n "Press a key...  "

# May need to also press ENTER if a key not listed above pressed.
read -n3 key                      # Read 3 characters.


# tefEdit Nb: adiing "> /dev/null 2>&1" after grep seems to have no effect ..
# tefEdit -> maybe it'd be possible by using `` & capturing the output inst

echo -en "\r$key" | grep "$arrowup"  #Check if character code detected.
if [ "$?" -eq $SUCCESS ]
then
  echo -en "\rUp-arrow key pressed."
  #exit $SUCCESS
else
  echo -en "\r"
fi
 
echo -en "\r$key" | grep "$arrowdown"
if [ "$?" -eq $SUCCESS ]
then
  echo -en "\rDown-arrow key pressed."
  #exit $SUCCESS
else
  echo -en "\r"
fi
 
echo -en "\r$key" | grep "$arrowrt"
if [ "$?" -eq $SUCCESS ]
then
  echo -en "\rRight-arrow key pressed."
  #exit $SUCCESS
else
  echo -en "\r"
fi
 
echo -en "\r$key" | grep "$arrowleft"
if [ "$?" -eq $SUCCESS ]
then
  echo -en "\rLeft-arrow key pressed."
  #exit $SUCCESS
else
  echo -en "\r"
fi
 
echo -n "$key" | grep "$insert"
if [ "$?" -eq $SUCCESS ]
then
  echo "\"Insert\" key pressed."
  #exit $SUCCESS
fi
 
echo -n "$key" | grep "$delete"
if [ "$?" -eq $SUCCESS ]
then
  echo "\"Delete\" key pressed."
  #exit $SUCCESS
fi
 
 
#echo " Some other key pressed."
 
#exit $OTHER

# tefEdit: add loo end
done

 
#  Exercises:
#  ---------
#  1) Simplify this script by rewriting the multiple "if" tests
#+    as a 'case' construct.
#  2) Add detection of the "Home," "End," "PgUp," and "PgDn" keys.