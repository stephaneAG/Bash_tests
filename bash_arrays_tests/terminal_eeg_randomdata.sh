#!/bin/bash

# terminal_eeg_randomdata.sh - little bash script displaying a random EEG-like animated drawing 
# by StephaneAG - 2014


## --

## - some functions -

# - array test functions -

# join array elements with something else than a space ( " ' ' " )
_join() { local IFS="$1"; shift; echo "$*"; }

# get an array as argument ( passed as " $var " )
_displayArray()
{
  local this
  while [ ${#} -gt 0 ] # while having more than 0 argument
  do
    this=${1}
    echo "${this[@]}" # display all array elements
    shift # reduce the number of arguments by 1 
  done
}

_displayArray2()
{
  local arr="$*"
  echo $arr # print whole sentence
  _join , $arr
}

_displayArray3()
{
  local this
  local new_arr # decalre explicitly ( mat not be needed )
  while [ ${#} -gt 0 ] # while having more than 0 argument
  do
    this=${1}
    #echo "${this[@]}" # display all array elements
    new_arr=("${new_arr[@]}" "${this[@]}") # add each element one by one to the 'new_arr' array
    shift # reduce the number of arguments by 1 
  done
  echo "${new_arr[@]}" # print all elements from the array
}

_displayArray4()
{
  local array=("$@")
  for i in "${array[@]}"; do echo "$i"; done
}

_displayArray5()
{
  local array=("$@")
  echo "${array[@]}"
}

_displayArrayDumboed()
{
  local array=("$@")
  array=("${array[@]}" "Dumbo")
  echo "${array[@]}"
}

_displayArrayIndexed()
{
  local array=("$@")
  for i in `seq 0 $(( ${#array[@]} - 1 ))`; do echo "$i : ${array[i]}"; done
}

_displayArraySimply()
{
  local array_string="$1[*]"
  local loc_array=(${!array_string})
  echo ${loc_array[@]}
}

# get a random element from an array passed as parameter
_getRandElemFromArray()
{
  local RANDOM=$$$(date +%s)
  
  local array_string="$1[*]"
  local loc_array=(${!array_string})

  local randElem=${loc_array[$RANDOM % ${#loc_array[@]}]}
  echo $randElem
}

# make use of the above function to add a random element to the array passed as parameter
_randomLastElemForArray()
{
  local array_string="$1[*]"
  local loc_array=(${!array_string})

  loc_array[$((${#loc_array[@]} - 1))]=`_getRandElemFromArray eeg_glyphs_top` # replace the last element in the array with a random element
  #loc_array[$((${#loc_array[@]} - 1))]=`_getRandElemFromArray eeg_glyphs_top_debug` # DEBUG

  #echo "the array now contains ${#loc_array[@]} elements"
  #for (( i = 0; i < ${#loc_array[@]}; i++ ))
  #do
  #  echo "element N° $(($i + 1)) at index: $i is : ${loc_array[i]}"
  #done

  echo "${loc_array[@]}" # return the new array's content
}

# 'slide down' an array passed as parameter
_slideDownArray()
{
  local array_string="$1[*]"
  local loc_array=(${!array_string}) # previsouly local

  #echo "the array contains ${#loc_array[@]} elements"

  for (( i = 0; i < $((${#loc_array[@]} - 1)); i++ ))
  {
    #echo "element N° $(($i + 1)) at index: $i is : ${loc_array[i]}"
    loc_array[i]="${loc_array[$(($i + 1))]}" # actually 'slide down' the elements
  }

  #echo "the array now contains ${#loc_array[@]} elements"
  #for (( i = 0; i < ${#loc_array[@]}; i++ ))
  #do
  #  echo "element N° $(($i + 1)) at index: $i is : ${loc_array[i]}"
  #done

  echo "${loc_array[@]}" # return the new array's content
}

# - random number test functions -
_randomNum1to10()
{
  echo $(( ( RANDOM % 10 ) + 1 ))
}

_randomNum0to10()
{
  echo $(( RANDOM % 10 ))
}

_randomNum2()
{
  echo $$$(date +%s)
}

# - cursor position helpers -
_saveContext(){
  tput sc # save cursor location
}
_restoreContext(){
  tput rc # restore cursor location
}

# - text printing helpers -
_clearLineAndEcho()
{
  echo -e "\r\033[K$1" # clear the current line from its very left to its end, even if there's less text than what was previsouly written 
}

# - main functions of the program -
echoDrawing()
{
  _clearLineAndEcho `_join '' ${eeg_drawing_top_line[@]}`
  _clearLineAndEcho `_join '' ${eeg_drawing_bottom_line[@]}`
}

echoDrawing_DEBUG()
{
  #_clearLineAndEcho `_join '_' ${eeg_drawing_top_line_debug[@]}`
  #_clearLineAndEcho `_join '' ${eeg_drawing_top_line_debug[@]}`
  _clearLineAndEcho `_join '.' ${eeg_drawing_top_line_debug[@]}`
}

updateDrawing()
{
  # 'slide down' the arrays
  #_slideDownArray eeg_drawing_top_line_debug # 'old' way of doing it
  local eeg_drawing_top_line_debug_TMP=`_slideDownArray eeg_drawing_top_line_debug` # same as above but use the stuff returned as new content
  _clearLineAndEcho "TEMP (sliding down elements | ${#eeg_drawing_top_line_debug_TMP[@]} elements): $eeg_drawing_top_line_debug_TMP"
  eeg_drawing_top_line_debug=("$eeg_drawing_top_line_debug_TMP")

  _clearLineAndEcho "Content of array (${#eeg_drawing_top_line_debug[@]} elements): ${eeg_drawing_top_line_debug[@]}"
  
  # get an random element from the arrays & add it as last element of the arrays
  #_randomLastElemForArray eeg_drawing_top_line_debug # 'old' way of doing it
  local eeg_drawing_top_line_debug_TMP=`_randomLastElemForArray eeg_drawing_top_line_debug`
  _clearLineAndEcho "TEMP (last element randomized | ${#eeg_drawing_top_line_debug_TMP[@]} elements): $eeg_drawing_top_line_debug_TMP"
  eeg_drawing_top_line_debug=("$eeg_drawing_top_line_debug_TMP")

  _clearLineAndEcho "Content of array (${#eeg_drawing_top_line_debug[@]} elements): ${eeg_drawing_top_line_debug[@]}"
}

## - some variables -

# the array of elements

#___ᐱ___ _____ᐱᐱ___ -> eeeg_glyphs_top signs
#       ᐯ           -> eeg_glyphs_bottom signs

declare -a eeg_glyphs_top=('ᐱ' ' ' '_');
declare -a eeg_glyphs_top_debug=('a' 'z' 'e');
declare -a eeg_glyphs_bottom=(' ' 'ᐯ' ' ')
# signgs:                   1st    2nd    3rd
#               top line <-  ᐱ             _
#            bottom line <-         ᐯ

# currently the lengths of the arrays are static ( .. )

# we start with a sraight line
# indexes                        1   2   3   4   5   6   7   8   9   10
declare -a eeg_drawing_top_line=('_' '_' '_' '_' '_' '_' '_' '_' '_' '_')
declare -a eeg_drawing_bottom_line=(' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' )
# indexes                           1   2   3   4   5   6   7   8   9   10
# debug version
declare -a eeg_drawing_top_line_debug=('n1' 'n2' 'n3' 'n4' 'n5' 'n6' 'n7' 'n8' 'n9' 'n10')

## --

# program start
declare -a testarray=('je' 'kifferais' 'que' 'ca' 'marche!')
declare -a testarray2=("tu" "kifferais" "que" "ca" "marche!")

# infinite loop
for (( ; ; ))
{
  #echo "Hello, world !"
  _saveContext # save the cursor position before writing to stdout
  updateDrawing # update the drawing
  _clearLineAndEcho "- drawing starts below -"
  #echoDrawing # display the drawing
  echoDrawing_DEBUG # debug version
  _clearLineAndEcho "- drawing stops above -"

  _clearLineAndEcho "random number testing .."
  _clearLineAndEcho "random number from 1 to 10: `_randomNum1to10`"
  _clearLineAndEcho "random number from 0 to 10: `_randomNum0to10`"

  _restoreContext # restore the cursor position as it was previously saved
  sleep 1
}

exit 0
## --
