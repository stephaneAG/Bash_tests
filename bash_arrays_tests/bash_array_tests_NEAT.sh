#!/bin/bash

# pre- terminal_eeg_randomdata.sh - little bash script displaying a random EEG-like animated drawing 
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

# print an array
_printArray()
{
  echo "placeholder"
}

# draw the visible array(s)
_drawArray()
{
  echo "placeholder"
}
_drawArrays()
{
  echo "placeholder"
}

# "slide down" the elements of the visible array(s)
_slideDownArray()
{
  echo "placeholder"
}
_slideDownArrays()
{
  echo "placeholder"
}

# replace the last element of the visible array(s)
_replaceArrayLast(){
  echo "placeholder"
}
_replaceArraysLast()
{
  echo "placeholder"
}

# clear the current drawing
_clearDrawing()
{
  echo "clearing the drawing !" # placeholder ( .. )
}

# get a random number
_getRandNum()
{
  echo "placeholder"
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

# - random number test functions -
_randomNum()
{
  echo $(( ( RANDOM % 10 ) + 1 ))
}

_randomNum2()
{
  echo $$$(date +%s)
}
## - some variables -

# the array of elements

#___ᐱ___ _____ᐱᐱ___ -> eeeg_glyphs_top signs
#       ᐯ           -> eeg_glyphs_bottom signs

declare -a eeg_glyphs_top=('ᐱ' ' ' '_');
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

## --

# program start
declare -a testarray=('je' 'kifferais' 'que' 'ca' 'marche!')
declare -a testarray2=("tu" "kifferais" "que" "ca" "marche!")
#original_ISF=$ISF # now done using 'unset'
#IFS=$' \t\n'
echo "${testarray[@]}"
echo "${eeg_drawing_top_line[@]}"
#ISF=$original_IFS
#unset IFS
#_printArray $testarray

#SAVE_IFS=$IFS
#IFS=","
#FOOJOIN="${Ftestarray2[*]}"
#IFS=$SAVE_IFS

#echo $testarray2

_join : ${testarray[@]}
_join '' ${testarray[@]}
_join '' ${eeg_drawing_top_line[@]}

#_join , a "b c" d #a,b c,d
#_join / var local tmp #var/local/tmp

_displayArray ${testarray[@]}
_displayArray4 ${testarray[@]} # also works with ""
_displayArray2 ${testarray[@]}
_displayArray3 ${testarray[@]}
_displayArray5 ${testarray[@]}
_displayArrayDumboed ${testarray[@]}
_displayArrayIndexed ${testarray[@]}
_displayArraySimply testarray
#_printArray $eeg_drawing_bottom_line[@]

_randomNum
_getRandElemFromArray testarray


exit 0
## --
